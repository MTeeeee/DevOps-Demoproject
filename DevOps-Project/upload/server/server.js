const express = require('express');
const { Client } = require('pg');
const bcrypt = require('bcrypt');
const cors = require('cors')
const app = express();
const port = 3001;
const ip = require('./ip_from_postgres'); // UNBEDINGT PRÜFEN DAS DIE RICHTIGE IP GEHOLT WIRD

// console.log(ip)

// PostgreSQL-Datenbankverbindung
const client = new Client({
    user: 'admindb',
    host: ip.ip,
    // host: '3.79.189.153',
    database: 'usersdb',
    password: 'admin-pw',
    port: 5432,
});

client.connect();

app.use(express.json());
app.use(cors())

// API-Endpunkt für die Anmeldung
app.post('/api/login', async (req, res) => {
    const { username, password } = req.body;

    // Überprüfen Sie, ob die Felder "username" und "password" vorhanden und nicht leer sind
    if (!username || !password || username.trim() === "" || password.trim() === "") {
        return res.status(400).json({ message: 'Benutzername und Passwort dürfen nicht leer sein' });
    }

    try {
        const result = await client.query('SELECT * FROM users WHERE username = $1', [username]);
        if (result.rows.length === 1) {
            const user = result.rows[0];
            const passwordMatch = await bcrypt.compare(password, user.password);
            if (passwordMatch) {
                res.json({ message: 'Erfolgreich angemeldet' });
            } else {
                res.status(401).json({ message: 'Ungültige Anmeldeinformationen - Passwort stimmt nicht überein' });
            }
        } else {
            res.status(401).json({ message: '- Ungültige Anmeldeinformationen - \n Benutzer nicht gefunden' });
        }
    } catch (error) {
        console.error('Fehler bei der Anmeldung:', error);
        res.status(500).json({ message: 'Ein Fehler ist aufgetreten' });
    }
});

// API Endpunkt für Registrierung
app.post('/api/register', async (req, res) => {
    const { username, password } = req.body;

    // Überprüfen Sie, ob die Felder "username" und "password" vorhanden und nicht leer sind
    if (!username || !password || username.trim() === "" || password.trim() === "") {
        return res.status(400).json({ message: 'Benutzername und Passwort dürfen nicht leer sein' });
    }

    try {
        // Überprüfen, ob der Benutzer bereits existiert
        const existingUser = await client.query('SELECT * FROM users WHERE username = $1', [username]);
        if (existingUser.rows.length > 0) {
            return res.status(400).json({ message: 'Benutzername bereits vergeben' });
        }
        console.log(existingUser)

        // Passwort hashen
        const saltRounds = 10;
        // const salt = bcrypt.genSaltSync(saltRounds);
        const salt = await bcrypt.genSalt(saltRounds);
        // const hashedPassword = bcrypt.hashSync(password, salt);
        const hashedPassword = await bcrypt.hash(password, salt);

        // Benutzer in die Datenbank einfügen
        await client.query('INSERT INTO users (username, password) VALUES ($1, $2)', [username, hashedPassword]);

        res.json({ message: 'Benutzer erfolgreich registriert' });
    } catch (error) {
        console.error('Fehler bei der Registrierung:', error);
        res.status(500).json({ message: 'Ein Fehler ist aufgetreten' });
    }
});

app.listen(port, () => {
    console.log(`Server läuft auf Port ${port}`);
});