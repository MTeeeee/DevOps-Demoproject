import React from "react";
import { useParams } from "react-router-dom";
import { useNavigate } from 'react-router-dom';
// import { useTheme } from '@mui/material/styles';
import './App.css';

function PrivatePage() {
    let { username } = useParams();
    const navigate = useNavigate();
    // const theme = useTheme();

    const handleLogout = () => {
        navigate('/');
    };

    return (
        <div>
            <div className="login-container">
                <div>
                    <div style={{ textAlign: 'center', color: 'black' }}>
                        <h2>Hallo, {username}</h2>
                        <h3>Willkommen im Userbereich</h3>
                    </div>
                    <div style={{ display: 'flex', justifyContent: 'center' }}>
                        <button className="button-custom, logout-button" onClick={handleLogout}>Ausloggen</button>
                    </div>
                </div>
            </div>
        </div>
    );
}

export default PrivatePage;
