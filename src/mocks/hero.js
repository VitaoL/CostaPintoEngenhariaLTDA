export const heroCoverData = {
  imageUrl: "/aeroportoAfonsoPena.jpg",
  caption:
    "Experiência em obras de infraestrutura que inspira o cuidado da Costa Pinto Engenharia LTDA em cada proposta.",
};

export function fetchHeroCoverData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar capa (hero)");
      } else {
        resolve(heroCoverData);
      }
    }, 300);
  });
}
