import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import { ThemeProvider } from '@mui/material/styles';
import theme from './theme';
import Login from './Login';
import Register from './Register';
import PrivatePage from './PrivatePage';
import HomePage from './HomePage';

function App() {
    return (
        <ThemeProvider theme={theme}>
            <Router>
                <Routes>
                    <Route path="/" element={<HomePage />} />
                    <Route path="/login" element={<Login />} />
                    <Route path="/register" element={<Register />} />
                    <Route path="/private/:username" element={<PrivatePage />} />
                </Routes>
            </Router>
        </ThemeProvider>
    );
}

export default App;
