import React from 'react';
import { useNavigate } from 'react-router-dom';
import './App.css';

function HomePage() {
    const navigate = useNavigate();

    return (
        <div className="login-container">
            <div>
                <div style={{ textAlign: 'center', color: 'black' }}>
                    <h1>Hallo liebe Gäste</h1>
                    <h2>
                        Willkommen beim Abschluss Projekt von Maik, Mete & Thomas
                        <br />
                        Thema: Mit Terraform und Ansible eine AWS Infrastruktur aufbauen.<br />
                        Es soll den Web Developern ermöglichen eine eigene Entwicklungsumgebung<br />
                        für Ihre Projekte mit nur wenigen Klicks starten zu können.<br />
                    </h2>
                    <p>
                        Wichtig: Man benötigt einen Login um weiter zu kommen<br />
                        Diesen kann man sich einfach ohne viel hin und her mit einem<br />
                        Klick auf "Registrieren" erstellen. (Es wird nichts dazu benötigt)
                    </p>
                    <p>Alternativ stellen wir Euch einen Universal Zugang über Zoom zur Verfügung</p>
                    <p>Viel Spaß</p>
                </div>
                <div style={{ display: 'flex', justifyContent: 'center' }}>
                    <button className="button-custom login-button" onClick={() => navigate('/login')}>Einloggen</button>
                    <button className="button-custom register-button" onClick={() => navigate('/register')}>Registrieren</button>
                </div>
            </div>
        </div>
    );
}

export default HomePage;
