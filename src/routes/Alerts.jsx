import { motion } from 'framer-motion';
import OwlMark from '../components/OwlMark';
import { streamConfig } from '../data/config';

export default function Alerts() {
  const copy = streamConfig.scenes.alerts;

  return (
    <main className="overlay-screen grid place-items-center p-12">
      <motion.section
        className="pixel-panel flex min-w-[780px] items-center gap-8 p-8 shadow-glow"
        initial={{ opacity: 0, y: -30, scale: 0.94 }}
        animate={{ opacity: 1, y: 0, scale: 1 }}
        transition={{ type: 'spring', stiffness: 110, damping: 14 }}
      >
        <OwlMark compact />
        <div>
          <p className="font-display text-2xl uppercase tracking-[0.2em] text-ember">{copy.eyebrow}</p>
          <h1 className="mt-1 font-display text-6xl text-honey">{copy.title}</h1>
          <p className="mt-3 text-3xl text-parchment">
            <span className="font-display text-ember">{copy.sampleName}</span> {copy.sampleAction}
          </p>
          <p className="mt-2 text-xl text-honey/80">{copy.subtitle}</p>
        </div>
      </motion.section>
    </main>
  );
}
