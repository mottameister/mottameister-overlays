import { motion } from 'framer-motion';
import { MessageCircle } from 'lucide-react';
import { streamConfig } from '../data/config';

export default function Chat() {
  return (
    <main className="overlay-screen flex items-end justify-start p-12">
      <motion.section
        className="pixel-panel w-[520px] p-6 shadow-glow"
        initial={{ opacity: 0, x: -24 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ duration: 0.55 }}
      >
        <header className="mb-5 flex items-center gap-3 border-b border-honey/20 pb-4">
          <MessageCircle className="h-7 w-7 text-cyan" />
          <h1 className="font-display text-4xl text-honey">{streamConfig.chat.title}</h1>
        </header>
        <div className="space-y-4">
          {streamConfig.chat.messages.map((message, index) => (
            <motion.article
              key={message.user}
              className="bg-night/45 p-4 shadow-insetPixel"
              initial={{ opacity: 0, y: 12 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.14 }}
            >
              <p className="mb-1 font-display text-xl text-cyan">{message.user}</p>
              <p className="text-xl leading-snug text-parchment">{message.text}</p>
            </motion.article>
          ))}
        </div>
      </motion.section>
    </main>
  );
}
