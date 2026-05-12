export const streamConfig = {
  brand: {
    name: 'A Toca da Coruja',
    englishName: 'Owl Nest',
    tagline: 'Cozy games, warm coffee, and tiny victories.',
    initials: 'TC',
  },
  creator: {
    name: 'Coruja',
    pronouns: '',
  },
  socials: [
    { label: 'Twitch', value: '@tocadacoruja' },
    { label: 'Instagram', value: '@tocadacoruja' },
    { label: 'YouTube', value: '/@tocadacoruja' },
  ],
  scenes: {
    starting: {
      eyebrow: 'Stream warming up',
      title: 'Starting Soon',
      subtitle: 'The lanterns are lit. Grab a snack and settle into the nest.',
      timerLabel: 'Live in a few moments',
    },
    brb: {
      eyebrow: 'Tiny pause',
      title: 'Be Right Back',
      subtitle: 'Refilling the mug and checking the campfire.',
      timerLabel: 'Back very soon',
    },
    ending: {
      eyebrow: 'Nest lights dimming',
      title: 'Thanks for Watching',
      subtitle: 'Take care, drink water, and bring your good stories next time.',
      timerLabel: 'See you soon',
    },
    offline: {
      eyebrow: 'Currently offline',
      title: 'The Nest Is Resting',
      subtitle: 'Follow the socials to catch the next cozy gaming night.',
      timerLabel: 'Next stream announced soon',
    },
    alerts: {
      eyebrow: 'Nest notice',
      title: 'New Supporter',
      subtitle: 'Thanks for keeping the lantern glowing.',
      sampleName: 'MoonlitMiner',
      sampleAction: 'followed the channel',
    },
  },
  chat: {
    title: 'Nest Chat',
    messages: [
      { user: 'fern_friend', text: 'The cozy vibes are immaculate.' },
      { user: 'pixel_porch', text: 'That build needs one more lantern.' },
      { user: 'amber_acorn', text: 'Hydration check!' },
    ],
  },
  goal: {
    label: 'Community Lantern Goal',
    current: 68,
    target: 100,
    unit: 'subs',
  },
};
