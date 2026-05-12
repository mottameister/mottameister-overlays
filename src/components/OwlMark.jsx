import { motion } from 'framer-motion';
import { streamConfig } from '../data/config';

export default function OwlMark({ compact = false }) {
  return (
    <motion.div
      className={`pixel-panel relative grid place-items-center ${compact ? 'h-24 w-24' : 'h-36 w-36'}`}
      initial={{ rotate: -2, scale: 0.94 }}
      animate={{ rotate: [0, -1.5, 1.5, 0], scale: 1 }}
      transition={{ duration: 6, repeat: Infinity, ease: 'easeInOut' }}
      aria-label={`${streamConfig.brand.name} owl mark`}
    >
      <div className="absolute inset-3 bg-purple/25 shadow-insetPixel pixel-corners" />
      <div className="relative grid gap-1">
        <div className="mx-auto grid grid-cols-2 gap-2">
          <span className="h-8 w-8 bg-cyan shadow-[inset_0_0_0_8px_#12091d]" />
          <span className="h-8 w-8 bg-pink shadow-[inset_0_0_0_8px_#12091d]" />
        </div>
        <div className="mx-auto h-4 w-4 rotate-45 bg-ember" />
        <div className="grid grid-cols-5 gap-1">
          {Array.from({ length: 10 }).map((_, index) => (
            <span key={index} className="h-2 w-2 bg-parchment/80" />
          ))}
        </div>
      </div>
      {!compact && (
        <span className="absolute -bottom-4 rounded-sm border border-cyan/30 bg-night/80 px-4 py-1 font-display text-lg tracking-normal text-honey">
          {streamConfig.brand.initials}
        </span>
      )}
    </motion.div>
  );
}
