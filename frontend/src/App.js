import logo from './logo.svg';
import './App.css';
import { Outlet, BrowserRouter, Routes, Route } from "react-router-dom";
import Layout from './Layout';
import Home from './Home'
import CreateSurvey from './CreateSurvey';


function App() {
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
