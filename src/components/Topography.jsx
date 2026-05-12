export default function Topography() {
  return (
    <div className="pointer-events-none absolute inset-0 opacity-55">
      <div className="absolute inset-x-0 bottom-0 h-72 bg-[linear-gradient(135deg,transparent_0_35%,rgba(49,66,43,0.75)_35%_45%,transparent_45%_100%)] bg-[length:160px_160px]" />
      <div className="absolute -bottom-10 left-0 h-36 w-full bg-bark/80 shadow-[0_-18px_48px_rgba(18,13,9,0.4)]" />
      <div className="absolute bottom-20 left-16 h-12 w-44 bg-moss" />
      <div className="absolute bottom-32 left-44 h-12 w-24 bg-moss" />
      <div className="absolute bottom-20 right-28 h-12 w-56 bg-moss" />
      <div className="absolute bottom-32 right-64 h-12 w-28 bg-moss" />
    </div>
  );
}
