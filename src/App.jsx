// src/App.jsx
import { useEffect, useState } from "react";

import Header from "./components/Header";
import Hero from "./components/Hero";
import Sobre from "./components/Sobre";
import Servicos from "./components/Servicos";
import Portfolio from "./components/Portfolio";
import Contato from "./components/Contato";
import Footer from "./components/Footer";

function App() {
  const [showSplash, setShowSplash] = useState(true);
  const [hideSplashAnimation, setHideSplashAnimation] = useState(false);

  useEffect(() => {
    // começa a esconder (fade) depois de 2s
    const timer1 = setTimeout(() => {
      setHideSplashAnimation(true);
    }, 2000);

    // remove do DOM depois da animação (ex: 600ms)
    const timer2 = setTimeout(() => {
      setShowSplash(false);
    }, 2600);

    return () => {
      clearTimeout(timer1);
      clearTimeout(timer2);
    };
  }, []);

  return (
    <div className="app-root">
      {/* Overlay do splash por cima do site */}
      {showSplash && (
        <div
          className={
            "splash-overlay" +
            (hideSplashAnimation ? " splash-overlay--hide" : "")
          }
        >
          <img
            src="/Logo_Costa_Pinto_Engenharia.png"
            alt="Logo Costa Pinto Engenharia"
            style={{
              width: "260px",
              maxWidth: "80%",
              objectFit: "contain",
              marginBottom: "1.25rem",
            }}
          />
          <p className="blink-text">Carregando...</p>
        </div>
      )}

      {/* Site normal já renderizado por baixo */}
      <Header />
      <main>
        <Hero />
        <Sobre />
        <Servicos />
        <Portfolio />
        <Contato />
      </main>
      <Footer />
    </div>
  );
}

export default App;
