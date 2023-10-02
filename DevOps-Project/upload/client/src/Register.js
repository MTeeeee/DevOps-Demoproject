import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './App.css';
import ip from './ip_from_backend';

function Register() {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [message, setMessage] = useState(null);
    const [error, setError] = useState(null);

    const navigate = useNavigate();

    const handleRegister = async () => {
        try {
            //console.log(`http://${ip}/api/register`);
            //const response = await fetch(`http://localhost:3001/api/register`, {
            const response = await fetch(`http://${ip}:3001/api/register`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ username, password }),
            });

            const data = await response.json();

            if (response.status === 200) {
                // Erfolgreich registriert
                console.log('Erfolgreich registriert');
                setMessage(data.message);
                setError(null);

                setTimeout(() => {
                    navigate('/login');
                }, 2500);
            } else {
                // Fehler bei der Registrierung
                console.error('Fehler bei der Registrierung');
                setError(data.message);
                setMessage(null);
            }
        } catch (error) {
            console.error('Netzwerkfehler oder Serverfehler', error);
            setError('Netzwerkfehler oder Serverfehler');
            setMessage(null);
        }
    };

    return (
        <div>
            <div className="login-container">
                <h2>Registrierung</h2>
                <form onSubmit={(e) => {
                    e.preventDefault();
                    handleRegister();
                }}>
                    <div>
                        <label className="input-label">
                            Benutzername:
                            <input
                                type="text"
                                value={username}
                                onChange={(e) => setUsername(e.target.value)}
                            />
                        </label>
                        <br />
                        <label className="input-label">
                            Passwort:
                            <input
                                type="password"
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                            />
                        </label>
                    </div>
                    <br />
                    <div>
                        <button type="submit">SignUp</button>
                        <button type="button" onClick={() => navigate('/login')}>Zurück zum Login</button>
                    </div>
                    <div>
                        <button type="button" onClick={() => navigate('/')}>Startseite</button>
                    </div>
                </form>
            </div>
            <div className="message">
                {message && <p style={{ color: 'green' }}>{message}</p>}
            </div>
            <div className="error">
                {error && <p style={{ color: 'red' }}>{error}</p>}
            </div>
        </div>
    );
}

export default Register;
