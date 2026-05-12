import { motion } from 'framer-motion';
import OwlMark from './OwlMark';
import SocialRail from './SocialRail';
import { streamConfig } from '../data/config';

export default function SceneFrame({ scene, align = 'center', children }) {
  const copy = streamConfig.scenes[scene];
  const alignment = align === 'left' ? 'items-start text-left' : 'items-center text-center';

  return (
    <main className="overlay-screen px-20 py-16">
      <div className="absolute left-12 top-10 text-parchment/70">
        <p className="font-display text-3xl text-honey">{streamConfig.brand.name}</p>
        <p className="text-sm uppercase tracking-[0.22em] text-ember/70">{streamConfig.brand.englishName}</p>
      </div>
      <SocialRail />
      <motion.section
        className={`relative z-10 flex h-full flex-col justify-center ${alignment}`}
        initial={{ opacity: 0, y: 24 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.8, ease: 'easeOut' }}
      >
        <OwlMark />
        <div className="mt-12 max-w-5xl">
          <p className="mb-5 font-display text-2xl uppercase tracking-[0.18em] text-ember">{copy.eyebrow}</p>
          <h1 className="font-display text-[116px] font-black leading-none text-parchment drop-shadow-[0_8px_0_rgba(75,47,29,0.75)]">
            {copy.title}
          </h1>
          <p className="mx-auto mt-7 max-w-3xl text-3xl leading-snug text-honey/90">{copy.subtitle}</p>
        </div>
        <div className="pixel-panel mt-12 min-w-[520px] px-10 py-5 text-center shadow-glow">
          <p className="font-display text-3xl text-honey">{copy.timerLabel}</p>
        </div>
        {children}
      </motion.section>
    </main>
  );
}
