import { Outlet, useLocation } from 'react-router-dom';
import Particles from '../components/Particles';
import Topography from '../components/Topography';

export default function AppShell() {
  const { pathname } = useLocation();
  const hasSceneBackdrop = ['/starting', '/brb', '/ending', '/offline', '/'].includes(pathname);

  return (
    <div className="relative h-screen w-screen overflow-hidden bg-transparent text-parchment">
      {hasSceneBackdrop && (
        <>
          <div className="absolute inset-0 bg-[radial-gradient(circle_at_15%_12%,rgba(181,23,255,0.35),transparent_36%),radial-gradient(circle_at_86%_20%,rgba(67,217,255,0.24),transparent_42%),radial-gradient(circle_at_50%_78%,rgba(255,79,216,0.15),transparent_48%),linear-gradient(180deg,#05030a_0%,#090711_56%,#0c0816_100%)]" />
          <div className="absolute inset-0 bg-[linear-gradient(rgba(247,242,255,0.035)_1px,transparent_1px),linear-gradient(90deg,rgba(247,242,255,0.035)_1px,transparent_1px)] bg-[length:24px_24px]" />
          <Topography />
          <Particles />
        </>
      )}
      <Outlet />
    </div>
  );
}
