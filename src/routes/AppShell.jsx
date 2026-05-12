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
          <div className="absolute inset-0 bg-[radial-gradient(circle_at_50%_35%,rgba(242,162,58,0.16),transparent_38%),linear-gradient(135deg,#120d09_0%,#21140d_48%,#16231a_100%)]" />
          <div className="absolute inset-0 bg-[linear-gradient(rgba(246,230,191,0.035)_1px,transparent_1px),linear-gradient(90deg,rgba(246,230,191,0.035)_1px,transparent_1px)] bg-[length:24px_24px]" />
          <Topography />
          <Particles />
        </>
      )}
      <Outlet />
    </div>
  );
}
