import { createTheme } from '@mui/material/styles';

const theme = createTheme({
    palette: {
        background: {
            default: '#191919'
        },
        primary: {
            main: '#1976d2', // Hauptfarbe für Primärelemente (Buttons, etc.)
        },
        secondary: {
            main: '#dc004e', // Hauptfarbe für sekundäre Elemente
        },
    },
    typography: {
        fontFamily: '"Roboto", "Helvetica", "Arial", sans-serif', // Die Haupt-Schriftart für Text in der App
        fontSize: 14, // Die Standard-Schriftgröße
    },
    components: {
        MuiButton: {
            styleOverrides: {
                root: {
                    margin: '0 auto',  // Zentriert den Button
                },
            },
        },
    },
    myCustomStyles: {
        fullWidth: {
            width: '100%',
            height: '100vh',
            display: 'flex',
            justifyContent: 'center',
            alignItems: 'center',
        },
        centeredButton: {
            display: 'flex',
            justifyContent: 'center',
            alignItems: 'center',
        },
        formContainer: {
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'flex-start',
            gap: '1rem',
        },
        inputField: {
            margin: '0.5rem 0',
        },
        buttonContainer: {
            display: 'flex',
            justifyContent: 'space-between',
            width: '100%',
        },
    },
});

export default theme;
