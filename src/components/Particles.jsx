const particles = Array.from({ length: 42 }, (_, index) => ({
  id: index,
  left: `${(index * 19) % 100}%`,
  top: `${(index * 31) % 100}%`,
  delay: `${(index % 9) * 0.45}s`,
  size: index % 5 === 0 ? 'h-2 w-2' : 'h-1.5 w-1.5',
}));

export default function Particles() {
  return (
    <div className="pointer-events-none absolute inset-0 overflow-hidden">
      {particles.map((particle) => (
        <span
          key={particle.id}
          className={`absolute ${particle.size} animate-twinkle bg-ember/70 shadow-[0_0_14px_rgba(242,162,58,0.55)]`}
          style={{ left: particle.left, top: particle.top, animationDelay: particle.delay }}
        />
      ))}
    </div>
  );
}
