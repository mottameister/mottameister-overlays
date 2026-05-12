import { motion } from 'framer-motion';

export default function Gameplay() {
  return (
    <main className="overlay-screen pointer-events-none">
      <motion.div
        className="gameplay-camera-ring"
        initial={{ opacity: 0, scale: 0.96 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.6, ease: 'easeOut' }}
      >
        <div className="gameplay-camera-ring__halo" />
        <div className="gameplay-camera-ring__core" />
      </motion.div>
    </main>
  );
}
