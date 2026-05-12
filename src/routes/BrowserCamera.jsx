import { motion } from 'framer-motion';

export default function BrowserCamera() {
  return (
    <main className="overlay-screen pointer-events-none">
      <motion.div
        className="browser-camera-frame"
        initial={{ opacity: 0, scale: 0.985 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.55, ease: 'easeOut' }}
      >
        <div className="browser-camera-frame__glow" />
        <div className="browser-camera-frame__edge" />
        <div className="browser-camera-frame__corner browser-camera-frame__corner--tl" />
        <div className="browser-camera-frame__corner browser-camera-frame__corner--tr" />
        <div className="browser-camera-frame__corner browser-camera-frame__corner--bl" />
        <div className="browser-camera-frame__corner browser-camera-frame__corner--br" />
      </motion.div>
    </main>
  );
}
