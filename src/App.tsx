import reactLogo from '../public/react.svg';
import dockerLogo from '../public/docker.svg';
import './App.css';

function App() {

    return (
        <>
            <div className="logo__aera">
                <div className="logo__aera__logo">
                    {reactLogo && <img src={reactLogo as string} className="logo react" alt="React logo"/>}
                </div>
                <div className="logo__aera__logo">
                    {reactLogo && <img src={dockerLogo as string} className="logo react" alt="React logo"/>}
                </div>
            </div>
            <h1>React & Docker</h1>
            <div className="card">
                <p>
                    Edit <code>src/App.tsx</code> and save to test HMR
                </p>
            </div>
            <p className="read-the-docs">
                Click on the Vite and React logos to learn more
            </p>
        </>
    );
}

export default App;
