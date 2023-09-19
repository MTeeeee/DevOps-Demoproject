import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './App.css';
import ip from './ip_from_backend';

function Login() {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [message, setMessage] = useState(null);
    const [error, setError] = useState(null);

    const navigate = useNavigate();

    const handleLogin = async () => {
        try {

            //console.log(`http://${ip}/api/login`);
            //const response = await fetch('http://localhost:3001/api/login', {
            const response = await fetch(`http://${ip}:3001/api/login`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ username, password }),
            });

            const data = await response.json();

            if (response.status === 200) {
                // Erfolgreich angemeldet
                console.log('Erfolgreich angemeldet');
                setMessage(data.message);
                setError(null);

                setTimeout(() => {
                    navigate(`/private/${username}`);
                }, 1500);
            } else {
                // Fehler beim Anmelden
                console.error('Fehler beim Anmelden');
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
                <h2>Login</h2>
                <form>
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
                        <button className="button" type="button" onClick={handleLogin}>Einloggen</button>
                        <button className="button" onClick={() => navigate('/register')}>Zur Registrierung</button>
                    </div>
                    <div>
                        <button className="button" onClick={() => navigate('/')}>Startseite</button>
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

export default Login;
