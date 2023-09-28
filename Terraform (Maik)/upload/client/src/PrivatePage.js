import React, { useState, useEffect } from "react";
// import React, { useState } from "react";
import { useParams } from "react-router-dom";
import { useNavigate } from 'react-router-dom';
import './App.css';

const API_GET_START = process.env.REACT_APP_API_GET_START;
const API_GET_DATA = process.env.REACT_APP_API_GET_DATA;

function PrivatePage() {
    let { username } = useParams();
    const navigate = useNavigate();
    const [responseMessage, setResponseMessage] = useState('');
    const [isError, setIsError] = useState(false);  // Zustand hinzufügen, um festzustellen, ob es sich um eine Fehlermeldung handelt
    const [isButtonActive, setIsButtonActive] = useState(false);
    const [sshData, setSshData] = useState('');
    const [hasDataBeenFetched, setHasDataBeenFetched] = useState(false);



    const handleLogout = () => {
        navigate('/');
    };

    const handleApiGatewayClick = () => {
        fetch(API_GET_START)
            .then(response => response.json())
            .then(data => {
                if (data.message) {
                    setResponseMessage(data.message);
                    setIsError(false);
                } else if (data.error) {
                    setResponseMessage(data.error);
                    setIsError(true);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                setResponseMessage("Es ist ein Fehler beim Abrufen der Daten aufgetreten.");
                setIsError(true);
            });

        // Timer starten, um den anderen Button nach 3 Minuten zu aktivieren
        const timer = setTimeout(() => {
            setIsButtonActive(true);
        }, 120000);

        // Es ist wichtig, den Timer zu löschen, wenn die Komponente unmountet wird.
        // Daher geben wir eine Cleanup-Funktion zurück.
        return () => clearTimeout(timer);
    };

    const handleApiDataClick = () => {
        fetch(API_GET_DATA)
            .then(response => response.json())
            .then(data => {
                if (data.message) {
                    setResponseMessage(data.message);
                    setIsError(false);
                    if (data.ssh_data) {
                        setSshData(data.ssh_data);
                    }
                } else if (data.error) {
                    setResponseMessage(data.error);
                    setIsError(true);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                setResponseMessage("Es ist ein Fehler beim Abrufen der Daten aufgetreten.");
                setIsError(true);
            });
        setHasDataBeenFetched(true);
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
                        <button className="button-custom, login-button" onClick={handleApiGatewayClick}>Launch DEV Environment</button>
                    </div>
                    <div style={{ display: 'flex', justifyContent: 'center', marginTop: '10px' }}>
                        <button
                            className={`button-custom login-button ${hasDataBeenFetched ? 'fetched-color' : isButtonActive ? 'active-color' : 'inactive-color'}`}
                            onClick={handleApiDataClick}
                            disabled={!isButtonActive}
                        >
                            Daten Abrufen
                        </button>
                    </div>
                    {/* <div>
                        <p style={{ color: 'red', fontWeight: 'bold' }}>Achtung:<br /> Der Button "Daten Abrufen"<br /> wird erst nach 2 Minuten nach dem<br /> Klick auf "Launch DEV Env." aktiv!<br /> Button wird dann "GRÜN"</p>
                    </div> */}
                </div>
            </div>
            <div className="message">
                {responseMessage && (
                    <p style={{ color: isError ? 'red' : 'green' }}>
                        {responseMessage}
                    </p>
                )}
            </div>
            <div className="ssh-data-container">
                {sshData && (
                    <pre style={{ color: isError ? 'red' : 'green' }}>{sshData}</pre>  // Verwenden Sie <pre> für vorformatierten Text
                )}
            </div>
        </div>
    );
}

export default PrivatePage;