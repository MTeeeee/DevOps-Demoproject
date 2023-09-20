import React from "react";
import { useParams } from "react-router-dom";
import { useNavigate } from 'react-router-dom';
import './App.css';

const API_GATEWAY_URL = process.env.REACT_APP_API_GATEWAY_URL;

function PrivatePage() {
    let { username } = useParams();
    const navigate = useNavigate();

    const handleLogout = () => {
        navigate('/');
    };

    const handleApiGatewayClick = () => {
        fetch(API_GATEWAY_URL)
            .then(response => response.json())
            .then(data => console.log(data))
            .catch(error => console.error('Error:', error));
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
                    <div style={{ display: 'flex', justifyContent: 'center' }}>
                        <button className="button-custom, login-button"onClick={() => handleApiGatewayClick()}>Launch DEV Environment</button>
                    </div>
                </div>
            </div>
        </div>
    );
}

export default PrivatePage;
