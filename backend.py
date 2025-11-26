from flask import Flask, request, jsonify
import logging
import os
import re
import json
import yt_dlp
import whisper
from pathlib import Path
from datetime import datetime, timedelta
from moviepy.editor import VideoFileClip

# --- Setup ---
app = Flask(__name__)
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Define a directory for temporary downloads
DOWNLOAD_DIR = Path.cwd() / "temp_video_downloads"
DOWNLOAD_DIR.mkdir(exist_ok=True)

# --- Video Transcription Class (from video_transcriber.py) ---
class VideoTranscriber:
    def __init__(self, model_size="base"):
        self.model_size = model_size
        self.model = None
        self.load_model()

    def load_model(self):
        logging.info(f"Loading Whisper model ({self.model_size})...")
        try:
            self.model = whisper.load_model(self.model_size)
            logging.info("Model loaded successfully")
        except Exception as e:
            logging.error(f"Error loading model: {e}")
            raise

    def extract_audio(self, video_path, audio_path):
        logging.info("Extracting audio from video...")
        try:
            with VideoFileClip(str(video_path)) as video:
                audio = video.audio
                audio.write_audiofile(str(audio_path), logger=None)
            logging.info(f"Audio extracted to {audio_path}")
            return True
        except Exception as e:
            logging.error(f"Error extracting audio: {e}")
            return False

    def transcribe_video(self, video_path):
        video_path = Path(video_path)
        if not video_path.exists():
            logging.error(f"Video file not found: {video_path}")
            return None

        temp_audio = DOWNLOAD_DIR / f"{video_path.stem}_temp_audio.wav"
        if not self.extract_audio(video_path, temp_audio):
            return None

        logging.info("Transcribing audio...")
        try:
            result = self.model.transcribe(str(temp_audio), word_timestamps=True)
            logging.info("Transcription completed")
            return result
        except Exception as e:
            logging.error(f"Error during transcription: {e}")
            return None
        finally:
            if temp_audio.exists():
                temp_audio.unlink()

    def format_timestamp(self, seconds):
        td = timedelta(seconds=seconds)
        total_seconds = int(td.total_seconds())
        hours, remainder = divmod(total_seconds, 3600)
        minutes, seconds = divmod(remainder, 60)
        return f"{hours:02d}:{minutes:02d}:{seconds:02d}"

    def search_keywords(self, transcript_data, keywords, context_words=5):
        if not transcript_data or not keywords:
            return []
        
        matches = []
        for segment in transcript_data.get('segments', []):
            segment_text = segment.get('text', '').strip()
            words = segment.get('words', [])
            
            for keyword in keywords:
                if re.search(re.escape(keyword), segment_text, re.IGNORECASE):
                    for word_info in words:
                        word_text = word_info.get('word', '').strip()
                        if re.search(re.escape(keyword), word_text, re.IGNORECASE):
                            start_time = word_info.get('start', segment.get('start', 0))
                            matches.append({
                                'keyword': keyword,
                                'timestamp': self.format_timestamp(start_time),
                                'text': segment_text
                            })
                            # Found a match in this segment for this keyword, break to avoid duplicates per segment
                            break 
        
        matches.sort(key=lambda x: x['timestamp'])
        return matches

# --- YouTube Download Function (from youtube_channel_transcriber.py) ---
def download_video(video_url, output_dir):
    logging.info(f"Starting download for URL: {video_url}")
    try:
        ydl_opts = {
            'outtmpl': str(output_dir / '%(id)s.%(ext)s'),
            'format': 'best[height<=480]', # Lower quality for speed
            'quiet': True,
            'no_warnings': True,
        }
        
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(video_url, download=True)
            if info:
                video_id = info.get('id', 'unknown_id')
                ext = info.get('ext', 'mp4')
                downloaded_file = output_dir / f"{video_id}.{ext}"
                if downloaded_file.exists():
                    logging.info(f"Successfully downloaded video to {downloaded_file}")
                    return downloaded_file
        return None
    except Exception as e:
        logging.error(f"Error downloading video: {e}")
        return None

# --- API Endpoint ---
@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint for status monitoring"""
    return jsonify({"status": "healthy", "service": "YouTube Analysis Backend"}), 200

@app.route('/analyze', methods=['POST'])
def analyze_video():
    data = request.get_json()
    if not data:
        return jsonify({"error": "Invalid JSON"}), 400

    video_url = data.get('video_url', '').strip()
    keywords = data.get('keywords', [])

    # Input validation
    if not video_url:
        return jsonify({"error": "Missing 'video_url'"}), 400
    
    # Validate YouTube URL format
    if 'youtube.com' not in video_url and 'youtu.be' not in video_url:
        return jsonify({"error": "Invalid YouTube URL. Must be a youtube.com or youtu.be link."}), 400
    
    # Ensure keywords is a list
    if not isinstance(keywords, list):
        return jsonify({"error": "'keywords' must be an array"}), 400
    
    # Clean and filter keywords
    keywords = [k.strip() for k in keywords if k and k.strip()]

    logging.info(f"Received analysis request for URL: {video_url} with {len(keywords)} keywords: {keywords}")

    video_path = None
    try:
        # 1. Download Video
        video_path = download_video(video_url, DOWNLOAD_DIR)
        if not video_path:
            return jsonify({"error": "Failed to download video. Check if URL is valid and video is accessible."}), 500

        # 2. Transcribe Video
        # Using "tiny" model for speed in this automated backend context.
        # Can be changed to "base" for more accuracy.
        transcriber = VideoTranscriber(model_size="tiny") 
        transcript_data = transcriber.transcribe_video(video_path)
        if not transcript_data:
            return jsonify({"error": "Failed to transcribe video. Video may be corrupted or format not supported."}), 500

        # 3. Search for Keywords
        matches = []
        if keywords:
            matches = transcriber.search_keywords(transcript_data, keywords)
        
        logging.info(f"Found {len(matches)} matches for keywords in {video_url}")
        if matches:
            for match in matches:
                logging.info(f"  - Match found: Keyword='{match['keyword']}' at {match['timestamp']}")
                logging.info(f"    Context: {match['text']}")
        elif keywords:
            logging.info(f"  No matches found for keywords: {', '.join(keywords)}")

        return jsonify({
            "message": f"Analysis complete. Found {len(matches)} matches.",
            "matches": matches,
            "keywords_searched": keywords
        }), 200

    except Exception as e:
        logging.error(f"An error occurred during analysis: {e}")
        return jsonify({"error": f"An internal error occurred: {str(e)}"}), 500
    finally:
        # 4. Clean up downloaded file
        if video_path and video_path.exists():
            video_path.unlink()
            logging.info(f"Cleaned up temporary video file: {video_path}")


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=False) # Debug off for production use