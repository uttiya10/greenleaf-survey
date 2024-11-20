import './App.css';
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Layout from './components/layout/Layout';
import Home from './components/home/Home'
import CreateSurvey from './components/create-survey/CreateSurvey';
import { SurveyList } from './components/saved-surveys/SavedSurveys';
import SurveyEntry from './components/survey-entry/SurveyEntry';
import { useEffect } from 'react';
import { OVERLAY_TOGGLE, subscribe } from './util/events';
import Responses from './components/responses/Responses';


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
          <Route path='saved' element={<SurveyList />}/>
          <Route path="survey/:id" element={<SurveyEntry />}/>
          <Route path="responses/:id" element={<Responses />}/>
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
