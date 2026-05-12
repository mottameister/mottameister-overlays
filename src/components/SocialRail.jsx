import { streamConfig } from '../data/config';

export default function SocialRail() {
  return (
    <aside className="absolute bottom-10 left-12 z-10 flex gap-4">
      {streamConfig.socials.map((social) => (
        <div key={social.label} className="pixel-chip">
          <span className="text-ember">{social.label}</span>
          <span className="text-parchment">{social.value}</span>
        </div>
      ))}
    </aside>
  );
}
