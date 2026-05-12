import { motion } from 'framer-motion';
import { Flame } from 'lucide-react';
import { streamConfig } from '../data/config';

export default function Goal() {
  const { label, current, target, unit } = streamConfig.goal;
  const percent = Math.min(100, Math.round((current / target) * 100));

  return (
    <main className="overlay-screen flex items-end justify-center p-12">
      <motion.section
        className="pixel-panel w-[920px] p-7 shadow-glow"
        initial={{ opacity: 0, y: 28 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.65 }}
      >
        <div className="mb-5 flex items-center justify-between gap-6">
          <div className="flex items-center gap-4">
            <Flame className="h-8 w-8 text-pink" />
            <h1 className="font-display text-4xl text-honey">{label}</h1>
          </div>
          <p className="font-display text-3xl text-parchment">
            {current}/{target} {unit}
          </p>
        </div>
        <div className="h-12 bg-night/70 p-2 shadow-insetPixel">
          <motion.div
            className="h-full bg-[linear-gradient(90deg,#b517ff,#ff4fd8,#43d9ff)]"
            initial={{ width: 0 }}
            animate={{ width: `${percent}%` }}
            transition={{ duration: 1.4, ease: 'easeOut' }}
          />
        </div>
      </motion.section>
    </main>
  );
}
