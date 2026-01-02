
export const finalClientsData = [
  { id: 1, name: "Vale", imageUrl: "/VALE.png", link: "" },
  { id: 2, name: "Motiva", imageUrl: "/motiva.png", link: "" },
  { id: 3, name: "Albras", imageUrl: "/albras.jpeg", link: "" },
  { id: 4, name: "AngloGold", imageUrl: "/anglo.jpeg", link: "" },
  { id: 5, name: "CSN", imageUrl: "/CSN.png", link: "" },
  { id: 6, name: "Rumo", imageUrl: "/Rumo.png", link: "" },
  { id: 7, name: "Minas Mais", imageUrl: "/MINASMAIS.jpeg", link: "" },
  { id: 8, name: "EcoRodovias", imageUrl: "/EcoRodovias.png", link: "" },
  { id: 9, name: "CPE", imageUrl: "/CPE.png", link: "" },
];

export function fetchFinalClientsData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) reject("Falha ao carregar clientes finais");
      else resolve(finalClientsData);
    }, 300);
  });
}