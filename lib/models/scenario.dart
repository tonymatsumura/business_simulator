class GameOption {
  final String text;
  final String feedback;
  final int score;

  GameOption({
    required this.text,
    required this.feedback,
    required this.score,
  });

  factory GameOption.fromMap(Map<String, dynamic> map) {
    return GameOption(
      text: map['text'],
      feedback: map['feedback'],
      score: map['score'],
    );
  }
}

class Scenario {
  final int round;
  final String title;
  final String context;
  final List<GameOption> options;

  Scenario({
    required this.round,
    required this.title,
    required this.context,
    required this.options,
  });

  factory Scenario.fromMap(Map<String, dynamic> map) {
    return Scenario(
      round: map['round'],
      title: map['title'],
      context: map['context'],
      options: (map['options'] as List)
          .map((opt) => GameOption.fromMap(opt as Map<String, dynamic>))
          .toList(),
    );
  }
}

final List<Scenario> gameScenarios = [
  Scenario(
    round: 1,
    title: "Cultura em Transformação",
    context: "A Vortex Solutions está passando por uma transformação digital, mas parte dos funcionários mais antigos está resistente às mudanças. Como consultor, você precisa sugerir uma abordagem para lidar com esta situação.",
    options: [
      GameOption(
        text: "Implementar as mudanças rapidamente e substituir funcionários resistentes",
        feedback: "Esta abordagem pode causar perda de conhecimento valioso e prejudicar o clima organizacional. Uma transformação precisa considerar as pessoas.",
        score: -10,
      ),
      GameOption(
        text: "Criar um programa de mentoria reversa, onde funcionários mais jovens ajudam os mais experientes com tecnologia",
        feedback: "Excelente escolha! Esta abordagem promove a integração entre gerações e facilita a transferência de conhecimento nos dois sentidos.",
        score: 20,
      ),
      GameOption(
        text: "Ignorar as reclamações e seguir com as mudanças conforme planejado",
        feedback: "Ignorar o feedback dos funcionários pode gerar desmotivação e aumentar a resistência às mudanças.",
        score: -5,
      ),
      GameOption(
        text: "Adiar a transformação digital até que todos estejam confortáveis",
        feedback: "Adiar a transformação pode fazer a empresa perder competitividade. É preciso encontrar um equilíbrio entre mudança e adaptação.",
        score: 0,
      ),
    ],
  ),
  Scenario(
    round: 2,
    title: "Expansão Internacional",
    context: "A Vortex Solutions recebeu uma proposta para expandir suas operações para o mercado asiático. É uma oportunidade promissora, mas requer um investimento significativo. Qual estratégia você recomenda?",
    options: [
      GameOption(
        text: "Expandir imediatamente com recursos próprios",
        feedback: "Uma expansão precipitada sem análise adequada do mercado e parceiros locais pode ser arriscada.",
        score: -5,
      ),
      GameOption(
        text: "Buscar um parceiro local para joint venture",
        feedback: "Ótima escolha! Um parceiro local pode fornecer insights valiosos sobre o mercado e reduzir riscos.",
        score: 20,
      ),
      GameOption(
        text: "Começar com um escritório de representação pequeno",
        feedback: "Uma abordagem cautelosa e gradual pode ser boa, mas pode fazer perder oportunidades iniciais importantes.",
        score: 10,
      ),
      GameOption(
        text: "Desistir da expansão e focar no mercado atual",
        feedback: "Evitar completamente oportunidades de expansão pode limitar o crescimento futuro da empresa.",
        score: 0,
      ),
    ],
  ),
  Scenario(
    round: 3,
    title: "Crise de Produto",
    context: "Um bug crítico foi descoberto em seu principal produto de software, afetando dados sensíveis dos clientes. A mídia ainda não descobriu, mas é questão de tempo. Como você lidaria com esta situação?",
    options: [
      GameOption(
        text: "Ocultar o problema e corrigir silenciosamente",
        feedback: "Falta de transparência pode destruir a confiança dos clientes e resultar em consequências legais graves.",
        score: -20,
      ),
      GameOption(
        text: "Informar apenas os clientes afetados discretamente",
        feedback: "Embora melhor que ocultar, ainda pode parecer falta de transparência quando a notícia vazar.",
        score: 5,
      ),
      GameOption(
        text: "Fazer um anúncio público imediato, detalhando o problema e as soluções",
        feedback: "Excelente! Transparência e proatividade são essenciais em crises, mesmo que cause impacto inicial negativo.",
        score: 20,
      ),
      GameOption(
        text: "Esperar até que alguém descubra e reagir depois",
        feedback: "Reativo e arriscado. Pode resultar em perda de confiança e danos à reputação maiores.",
        score: -10,
      ),
    ],
  ),
  Scenario(
    round: 4,
    title: "Inovação vs. Estabilidade",
    context: "A equipe de P&D propôs uma reformulação radical dos produtos existentes usando IA. É arriscado, mas poderia revolucionar o mercado. O que você recomenda?",
    options: [
      GameOption(
        text: "Investir todos os recursos disponíveis na nova tecnologia",
        feedback: "Muito arriscado. É importante manter um equilíbrio entre inovação e estabilidade.",
        score: -5,
      ),
      GameOption(
        text: "Criar um projeto piloto com recursos limitados",
        feedback: "Ótima escolha! Permite testar a inovação sem comprometer a operação atual.",
        score: 20,
      ),
      GameOption(
        text: "Ignorar a proposta e manter o foco nos produtos atuais",
        feedback: "Conservador demais. Ignorar inovação pode levar à obsolescência.",
        score: -10,
      ),
      GameOption(
        text: "Formar parceria com uma startup especializada em IA",
        feedback: "Boa estratégia! Reduz riscos e acelera a inovação.",
        score: 15,
      ),
    ],
  ),
  Scenario(
    round: 5,
    title: "Gestão de Talentos",
    context: "Dois funcionários-chave receberam ofertas de concorrentes. Ambos são essenciais para projetos críticos. Como reter esses talentos?",
    options: [
      GameOption(
        text: "Oferecer aumento salarial significativo para ambos",
        feedback: "Solução de curto prazo que pode criar problemas de equidade salarial.",
        score: 5,
      ),
      GameOption(
        text: "Desenvolver um plano de carreira personalizado com novos desafios",
        feedback: "Excelente! Demonstra preocupação com desenvolvimento profissional e engajamento.",
        score: 20,
      ),
      GameOption(
        text: "Ignorar as ofertas; todos são substituíveis",
        feedback: "Péssima abordagem que pode resultar em perda de conhecimento valioso.",
        score: -20,
      ),
      GameOption(
        text: "Criar programa de participação nos resultados",
        feedback: "Boa ideia que beneficia toda a equipe e aumenta o comprometimento.",
        score: 15,
      ),
    ],
  ),
  Scenario(
    round: 6,
    title: "Sustentabilidade Empresarial",
    context: "Investidores pressionam por metas ESG mais ambiciosas, mas implementá-las aumentaria custos em 15%. Qual sua recomendação?",
    options: [
      GameOption(
        text: "Ignorar a pressão e manter o foco em resultados financeiros",
        feedback: "Visão ultrapassada que pode prejudicar a empresa no longo prazo.",
        score: -15,
      ),
      GameOption(
        text: "Implementar mudanças gradualmente em 3 anos",
        feedback: "Boa estratégia! Equilibra responsabilidade com viabilidade financeira.",
        score: 20,
      ),
      GameOption(
        text: "Fazer marketing verde sem mudanças significativas",
        feedback: "Greenwashing é antiético e pode causar graves danos à reputação.",
        score: -20,
      ),
      GameOption(
        text: "Buscar financiamento verde para projetos sustentáveis",
        feedback: "Excelente! Mostra comprometimento e encontra formas viáveis de implementação.",
        score: 15,
      ),
    ],
  ),
  Scenario(
    round: 7,
    title: "Gestão de Crise",
    context: "Um ataque cibernético afetou sistemas críticos da empresa. A equipe de TI estima 48h para recuperação completa. Como proceder?",
    options: [
      GameOption(
        text: "Pagar o resgate exigido pelos hackers",
        feedback: "Perigoso e pode incentivar mais ataques, além de questões legais.",
        score: -20,
      ),
      GameOption(
        text: "Acionar plano de contingência e comunicar stakeholders",
        feedback: "Excelente! Transparência e preparo são essenciais em crises.",
        score: 20,
      ),
      GameOption(
        text: "Tentar resolver internamente sem comunicar ninguém",
        feedback: "Falta de transparência pode agravar a crise.",
        score: -10,
      ),
      GameOption(
        text: "Contratar consultoria especializada em segurança",
        feedback: "Boa ideia, mas deve ser combinada com comunicação adequada.",
        score: 10,
      ),
    ],
  ),
  Scenario(
    round: 8,
    title: "Expansão de Mercado",
    context: "Uma oportunidade surgiu para adquirir um concorrente menor, mas inovador. O preço é alto e exigiria financiamento. O que fazer?",
    options: [
      GameOption(
        text: "Fazer a aquisição imediatamente",
        feedback: "Precipitado sem due diligence adequada.",
        score: -10,
      ),
      GameOption(
        text: "Propor parceria estratégica primeiro",
        feedback: "Excelente! Permite avaliar sinergias com menor risco.",
        score: 20,
      ),
      GameOption(
        text: "Ignorar e focar em crescimento orgânico",
        feedback: "Pode perder oportunidade estratégica importante.",
        score: 0,
      ),
      GameOption(
        text: "Fazer due diligence completa antes de decidir",
        feedback: "Abordagem prudente e profissional.",
        score: 15,
      ),
    ],
  ),
  Scenario(
    round: 9,
    title: "Cultura Organizacional",
    context: "Pesquisa de clima indicou baixo engajamento e alta rotatividade. Como melhorar o ambiente organizacional?",
    options: [
      GameOption(
        text: "Aumentar salários generalizadamente",
        feedback: "Solução superficial que não aborda causas fundamentais.",
        score: 5,
      ),
      GameOption(
        text: "Implementar programa de bem-estar e desenvolvimento",
        feedback: "Excelente! Aborda tanto sintomas quanto causas.",
        score: 20,
      ),
      GameOption(
        text: "Ignorar resultados; foco em produtividade",
        feedback: "Péssima escolha que agravará os problemas.",
        score: -20,
      ),
      GameOption(
        text: "Criar comitê de cultura com funcionários",
        feedback: "Boa iniciativa participativa.",
        score: 15,
      ),
    ],
  ),
  Scenario(
    round: 10,
    title: "Legado e Futuro",
    context: "Como CEO, você deve apresentar o plano estratégico para os próximos 5 anos. Qual sua visão para a Vortex Solutions?",
    options: [
      GameOption(
        text: "Foco em maximização de lucros de curto prazo",
        feedback: "Visão limitada que pode comprometer sustentabilidade.",
        score: -10,
      ),
      GameOption(
        text: "Equilíbrio entre inovação, pessoas e resultados",
        feedback: "Excelente! Visão holística e sustentável.",
        score: 20,
      ),
      GameOption(
        text: "Vender a empresa para um grande player",
        feedback: "Falta de comprometimento com o futuro da organização.",
        score: -5,
      ),
      GameOption(
        text: "Investir pesadamente em tecnologias emergentes",
        feedback: "Arriscado sem considerar outros aspectos do negócio.",
        score: 5,
      ),
    ],
  ),
];
