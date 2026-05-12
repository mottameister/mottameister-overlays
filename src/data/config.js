export const streamConfig = {
  brand: {
    name: 'A Toca da Coruja',
    englishName: '@mottameister',
    tagline: 'Gaming, comunidade e vida real dentro da Toca da Coruja.',
    initials: 'TC',
  },
  creator: {
    name: 'Motta',
    pronouns: '',
  },
  socials: [
    { label: 'Twitch', value: '@mottameister' },
    { label: 'Instagram', value: '@mottameister' },
    { label: 'YouTube', value: '/@mottameister' },
    { label: 'Site', value: 'mottameister.xyz' },
  ],
  scenes: {
    starting: {
      eyebrow: 'Preparando a live',
      title: 'Já Já Começa',
      subtitle: 'A Toca está acendendo as luzes. Pega uma água, abre o Discord e cola com a gente.',
      timerLabel: 'Entrando ao vivo em instantes',
    },
    brb: {
      eyebrow: 'Pausa rápida',
      title: 'Já Volto',
      subtitle: 'O Motta foi resolver uma coisa rapidinho. Não sai daí que a aventura continua.',
      timerLabel: 'Voltamos em poucos minutos',
    },
    ending: {
      eyebrow: 'Fechando a Toca',
      title: 'Valeu Pela Live',
      subtitle: 'Obrigado por jogar, conversar e construir essa comunidade comigo. Até a próxima.',
      timerLabel: 'Nos vemos na próxima live',
    },
    offline: {
      eyebrow: 'Offline no momento',
      title: 'A Toca Está Descansando',
      subtitle: 'Segue os links e entra no Discord para saber quando a próxima live começa.',
      timerLabel: 'Próxima live anunciada em breve',
    },
    alerts: {
      eyebrow: 'Aviso da Toca',
      title: 'Novo Apoio',
      subtitle: 'Obrigado por fortalecer a comunidade.',
      sampleName: 'TreinadorCoruja',
      sampleAction: 'chegou junto na live',
    },
  },
  chat: {
    title: 'Chat da Toca',
    messages: [
      { user: 'coruja_do_discord', text: 'Hoje tem campanha ou build no servidor?' },
      { user: 'treinador_pixel', text: 'Esse time ficou forte demais.' },
      { user: 'modpack_br', text: 'Lembrete de água para todo mundo!' },
    ],
  },
  goal: {
    label: 'Meta da Comunidade',
    current: 68,
    target: 100,
    unit: 'subs',
  },
};
