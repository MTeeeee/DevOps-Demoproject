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
    const [isError, setIsError] = useState(false);
    const [isButtonActive, setIsButtonActive] = useState(false);
    const [sshData, setSshData] = useState('');
    const [hasDataBeenFetched, setHasDataBeenFetched] = useState(false);
    const [isLoading, setIsLoading] = useState(false);
    const [hasEnvStarted, setHasEnvStarted] = useState(false);

    useEffect(() => {
        let timer;
        if (hasEnvStarted && !isButtonActive) {
            timer = setTimeout(() => {
                setIsButtonActive(true);
            }, 180000);
        }
    
        return () => clearTimeout(timer);
    }, [hasEnvStarted]);


    const handleLogout = () => {
        navigate('/');
    };

    const handleApiGatewayClick = () => {
        setIsLoading(true);
        setHasEnvStarted(true);

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
                setIsLoading(false);
            })
            .catch(error => {
                console.error('Error:', error);
                setResponseMessage("Es ist ein Fehler beim Abrufen der Daten aufgetreten.");
                setIsError(true);
                setIsLoading(false);
            });


    };

    const handleApiDataClick = () => {
        setIsLoading(true);

        fetch(API_GET_DATA)
            .then(response => response.json())
            .then(data => {
                if (data.message) {
                    setResponseMessage(data.message);
                    setIsError(false);
                    if (data.ssh_data) {
                        setSshData(data.ssh_data);
                    }
                    setHasDataBeenFetched(true);
                } else if (data.error) {
                    setResponseMessage(data.error);
                    setIsError(true);
                }
                setIsLoading(false);
            })
            .catch(error => {
                console.error('Error:', error);
                setResponseMessage("Es ist ein Fehler beim Abrufen der Daten aufgetreten.");
                setIsError(true);
                setIsLoading(false);
            });
    };


    return (
        <div>
            <div className="login-container">
                <div>
                    <div style={{ textAlign: 'center', color: 'black' }}>
                        <h2>Hallo, {username}</h2>
                        <h3>Willkommen im Userbereich</h3>
                        <h3>
                            Bitte beachte, dass der Start der Umgebung bis zu 5 Minuten dauern kann.<br />
                            Wenn alles bereit ist, wird der Button „Zugangsdaten abrufen“ grün.<br />
                            Aber Achtung, die Daten können nur einmal abgerufen.<br />
                            Danach verschwindet der Button. Zur Sicherheit werden die Zugangsdaten<br />
                            aber nochmal in einem Slack Channel gepostet (https://slack.com/)<br />

                            Bei Problemen bitte einen Admin kontaktieren. Viel Spass<br />
                        </h3>
                    </div>
                    <div style={{ display: 'flex', justifyContent: 'center' }}>
                        <button className="button-custom logout-button" onClick={handleLogout}>Ausloggen</button>
                    </div>
                    <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
                        <button className="button-custom login-button" onClick={handleApiGatewayClick}>
                            Entwicklungsumgebung Starten
                        </button>
                    </div>
                    {!hasDataBeenFetched && (
                        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', marginTop: '10px' }}>
                            <button
                                className={`button-custom login-button ${hasDataBeenFetched ? 'fetched-color' : isButtonActive ? 'active-color' : 'inactive-color'}`}
                                onClick={handleApiDataClick}
                                disabled={!isButtonActive}
                            >
                                Zugangsdaten Abrufen
                            </button>
                            {isLoading && <p className="blinking-text">Bitte Warten...</p>}
                        </div>
                    )}
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