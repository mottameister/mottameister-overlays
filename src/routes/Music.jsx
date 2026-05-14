import { motion } from 'framer-motion';
import { Music2 } from 'lucide-react';
import { useEffect, useMemo, useState } from 'react';
import { streamConfig } from '../data/config';

const normalizeTrack = (track) => ({
  title: track?.title || streamConfig.music.title,
  artist: track?.artist || streamConfig.music.artist,
  album: track?.album || streamConfig.music.album,
  cover: track?.cover || streamConfig.music.cover,
  isPlaying: track?.isPlaying ?? true,
  progress: Number(track?.progress || 0),
  duration: Number(track?.duration || 0),
});

export default function Music() {
  const params = useMemo(() => new URLSearchParams(window.location.search), []);
  const source = params.get('source');
  const [track, setTrack] = useState(() =>
    normalizeTrack({
      title: params.get('title'),
      artist: params.get('artist'),
      album: params.get('album'),
      cover: params.get('cover'),
      progress: params.get('progress'),
      duration: params.get('duration'),
      isPlaying: params.get('playing') !== 'false',
    }),
  );

  useEffect(() => {
    if (!source) return undefined;

    let active = true;

    const loadTrack = async () => {
      try {
        const response = await fetch(source, { cache: 'no-store' });
        if (!response.ok) return;
        const data = await response.json();
        if (active) setTrack(normalizeTrack(data));
      } catch {
        // Keep the last visible track if the data source blips.
      }
    };

    loadTrack();
    const timer = window.setInterval(loadTrack, 5000);

    return () => {
      active = false;
      window.clearInterval(timer);
    };
  }, [source]);

  const progressPercent = track.duration > 0 ? Math.min(100, Math.round((track.progress / track.duration) * 100)) : 42;

  return (
    <main className="overlay-screen pointer-events-none">
      <motion.section
        className="music-overlay"
        initial={{ opacity: 0, x: -24, scale: 0.98 }}
        animate={{ opacity: 1, x: 0, scale: 1 }}
        transition={{ duration: 0.55, ease: 'easeOut' }}
      >
        <div className="music-overlay__cover">
          {track.cover ? (
            <img src={track.cover} alt="" />
          ) : (
            <div className="music-overlay__cover-fallback">
              <Music2 className="h-10 w-10" />
            </div>
          )}
        </div>

        <div className="music-overlay__content">
          <div className="music-overlay__eyebrow">
            <span className={track.isPlaying ? 'music-overlay__dot' : 'music-overlay__dot music-overlay__dot--paused'} />
            Tocando agora
          </div>
          <div className="music-overlay__title">{track.title}</div>
          <div className="music-overlay__artist">{track.artist}</div>
          <div className="music-overlay__bar">
            <motion.div
              className="music-overlay__bar-fill"
              initial={{ width: 0 }}
              animate={{ width: `${progressPercent}%` }}
              transition={{ duration: 0.7, ease: 'easeOut' }}
            />
          </div>
        </div>

        <div className="music-overlay__meter" aria-hidden="true">
          {Array.from({ length: 5 }).map((_, index) => (
            <span key={index} style={{ animationDelay: `${index * 0.14}s` }} />
          ))}
        </div>
      </motion.section>
    </main>
  );
}
