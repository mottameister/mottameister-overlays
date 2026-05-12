import React from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom';
import AppShell from './routes/AppShell.jsx';
import Alerts from './routes/Alerts.jsx';
import Brb from './routes/Brb.jsx';
import Camera from './routes/Camera.jsx';
import Chat from './routes/Chat.jsx';
import Ending from './routes/Ending.jsx';
import Goal from './routes/Goal.jsx';
import Gameplay from './routes/Gameplay.jsx';
import Offline from './routes/Offline.jsx';
import Starting from './routes/Starting.jsx';
import './styles.css';

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <BrowserRouter>
      <Routes>
        <Route element={<AppShell />}>
          <Route index element={<Navigate to="/starting" replace />} />
          <Route path="/starting" element={<Starting />} />
          <Route path="/brb" element={<Brb />} />
          <Route path="/ending" element={<Ending />} />
          <Route path="/offline" element={<Offline />} />
          <Route path="/camera" element={<Camera />} />
          <Route path="/gameplay" element={<Gameplay />} />
          <Route path="/chat" element={<Chat />} />
          <Route path="/goal" element={<Goal />} />
          <Route path="/alerts" element={<Alerts />} />
        </Route>
      </Routes>
    </BrowserRouter>
  </React.StrictMode>,
);
