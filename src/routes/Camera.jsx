import { motion } from 'framer-motion';
import OwlMark from '../components/OwlMark';
import { streamConfig } from '../data/config';

export default function Camera() {
  return (
    <main className="overlay-screen p-12">
      <motion.div
        className="camera-frame absolute inset-10"
        initial={{ opacity: 0, scale: 0.985 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.7 }}
      >
        <div className="absolute left-8 top-8 flex items-center gap-5">
          <OwlMark compact />
          <div>
            <p className="font-display text-4xl text-honey">{streamConfig.brand.name}</p>
            <p className="text-lg uppercase tracking-[0.2em] text-cyan/80">Camera da Toca</p>
          </div>
        </div>
        <div className="absolute bottom-8 right-8 pixel-panel px-8 py-4">
          <p className="font-display text-3xl text-parchment">{streamConfig.brand.tagline}</p>
        </div>
      </motion.div>
    </main>
  );
}
