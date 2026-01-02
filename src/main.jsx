import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import './styles/header.css'
import './styles/hero.css'
import './styles/sobre.css'
import './styles/servicos.css'
import './styles/portfolio.css'
import './styles/contato.css'
import './styles/footer.css'
import App from './App.jsx'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <App />
  </StrictMode>,
)
