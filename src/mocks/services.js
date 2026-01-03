// src/mocks/services.js (ou onde você guarda isso)
export const contractorCompaniesData = [
  { id: 1, name: "Aterpa", imageUrl: "/aterpa.png", link: "" },
  { id: 2, name: "Cowan", imageUrl: "/cowan.jpeg", link: "" },
  { id: 3, name: "Engenharia de Obras", imageUrl: "/engenhariadeobras.jpeg", link: "" },
  { id: 4, name: "Andrade", imageUrl: "/andrade.png", link: "" },
  { id: 5, name: "BTEC", imageUrl: "/btec.jpeg", link: "" },
  { id: 6, name: "Barbosa Mello", imageUrl: "/barbosamelo.png", link: "" },
  { id: 7, name: "Concremat", imageUrl: "/CONCREMAT.png", link: "" },
  { id: 8, name: "CCR", imageUrl: "/CCR.png", link: "" },
];


export function fetchContractorCompaniesData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) reject("Falha ao carregar empresas contratantes");
      else resolve(contractorCompaniesData);
    }, 300);
  });
}

