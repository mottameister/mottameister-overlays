import { motion } from 'framer-motion';
import { MessageCircle } from 'lucide-react';
import { streamConfig } from '../data/config';

export default function Chat() {
  return (
    <main className="overlay-screen">
      <motion.section
        className="chat-frame"
        initial={{ opacity: 0, x: -24 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ duration: 0.55 }}
      >
        <header className="chat-frame__header">
          <MessageCircle className="h-5 w-5 text-cyan" />
          <h1>{streamConfig.chat.title}</h1>
        </header>
        <div className="chat-frame__slot" />
      </motion.section>
    </main>
  );
}
