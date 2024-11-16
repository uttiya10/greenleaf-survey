import './App.css';
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Layout from './components/layout/Layout';
import Home from './components/home/Home'
import CreateSurvey from './components/create-survey/CreateSurvey';
import { useEffect } from 'react';
import { OVERLAY_TOGGLE, subscribe } from './util/events';


function App() {
  useEffect(() => {
    subscribe(OVERLAY_TOGGLE, e => {
      if (e.detail.show) {
        document.getElementById('root').classList.add('faded-out')
      } else {
        document.getElementById('root').classList.remove('faded-out')
      }
    });
  }, []);
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Layout />}>
          <Route index element={<Home />}/>
          <Route path='create' element={<CreateSurvey />}/>
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
