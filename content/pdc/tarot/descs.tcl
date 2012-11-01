# descs.tcl -- Descriptions for tarot cards			 -*-tcl-*-
# Time-stamp: <pdc 2003-11-29>

# Each card has a symbolic name.
# For the trumps, it is prefixed with the roman numerals 
# for the card's ordinal (with 0 used for the Fool);
# the definite article is elided:
# 
#  0-fool, i-magician, ii-papess, ...
#
# For the suits, it is the suit name followed by the rank:
#
#  wands-ace, wands-2, wands-3, ..., wands-10, 
#  wands-page, wands-knight, wands-queen, wands-king
#
# The suits are called wands, cups, swords, and coins.
#
# For each of these we can define several array entries:
#
#  cardDescs(CARD) -- a multi-paragraph discussion of its interpretation
#  STATEKeywords(CARD) -- keywords for the card; the state is 
#    either upright or reversed
#  cardTitles(CARD) -- the title of the card, if it cannot be deduced
#    from CARD easily.

array set cardTitles {
    viii-justice "VIII. Justice"
    x-wheel "X. The Wheel of Fortune"
    xi-strength "XI. Strength"
    xii-hanged "XII. The Hanged Man"
    xiii-death "XIII. Death"
    xiiii-temperance "XIIII. Temperance"
    xx-judgement "XX. Judgement"
}
array set uprightKeywords {
    0-fool "sponteneity, trust, taking a risk"
    i-magician "skill, confidence, communication"
    ii-papess "intuition, dreams, anima"
    iii-empress "security, well-being, motherhood"
    iiii-emperor "authority, responsibility, promotion"
    v-pope "professional advice, learning, teaching"
    vi-lovers "choice, decision, commitment"
    vii-chariot "willpower, ambition"
    viii-justice "justice, reason, legal matters"
    viiii-hermit "independence, solitariness, inner search"
    x-wheel "good luck, chance event"
    xi-strength "moral strength, self-control"
    xii-hanged "sacrifice, dedication"
    xiii-death "change, ending, new life"
    xiiii-temperance "balanced personality, tactfulness"
    xv-devil "anger, oppressiveness, restriction"
    xvi-tower "shock, revelation, accident"
    xvii-star "peace, healing, rest"
    xviii-moon "confusion, depression, deception"
    xviiii-sun "success, optimism, high ideals"
    xx-judgement "assessment, satisfying outcome"
    xxi-world "completion, spiritual wholeness, freedom"
    coins-ace "feelings, security, wealth"
    coins-2 "practical ability, adapatability, harmonious change"
    coins-3 "work, employment"
    coins-4 "stability, stifling security"
    coins-5 "material trouble, poverty, worry"
    cups-ace "emotion, love, psychic powers"
    cups-2 "love, friendship, marriage"
    cups-3 "growth, birth, marriange"
    cups-4 "apathy, boredom, excess"
    cups-5 "partial loss, disapointment"
    swords-ace "intellect, reason, justice"
    swords-2 "balance, peace restored, truce"
    swords-3 "sorrow, destruction, strife"
    swords-4 "rest from strife, recuperation"
    swords-5 "defeat, humiliation"
    wands-ace "inspiration, enthusiasm, ambition"
    wands-2 "decision, initial success, self-doubt"
    wands-3 "creative ideas, laying plans, luck"
    wands-4 "free expression, creative work, holiday"
    wands-5 "minor problems, struggle"
    wands-6 "victory, triumph"
    cups-6 "pleasant memories, old friends, childhood"
    swords-6 "improvement, passage, journey"
    coins-6 "gift, charity"
    wands-7 "challenge, test, valour"
    cups-7 "fantasy, illusion, choice"
    swords-7 "foresight, evasion, disarming the opposition"
    coins-7 "perseverance, discouraging circumstances"
    wands-8 "swiftness, activity, rapid conclusion"
    cups-8 "moving on, personal; development, sacrifice"
    swords-8 "restriction, impediment"
    coins-8 "skilled work, crafts, self-employment"
    wands-9 "strength, courageous persistence"
    cups-9 "happines, optimism, hospitality"
    swords-9 "despair, depression, mental anguish"
    coins-9 "material gain, security achieved through effort"
    wands-ten "burden of responsibility, too many commitments"
    cups-ten "fulfilment, joy, happy family"
    swords-ten "crisis, ruin, unlucky group of people"
    coins-ten "family support, friends, inheritance"
    wands-page "a traveller, enthusiastic, impulsive"
    wands-knight "a warrior, generous, hasty"
    wands-queen "a practical organizer; lively, active, creative"
    wands-king "an athletic man, just, kind, and generous"
    cups-page "a young person, gentle, loving, artistic, insigntful"
    cups-knight "a sensitive, idealistic, romantic young man"
    cups-queen "a warm, sympathetic and sociable woman"
    cups-king "a sociable, loving, sensuous man"
    swords-page "sharp intelligence, change, vigilance"
    swords-knight "strong personality, domineering, conflict"
    swords-queen "a mature woman, keen perception, independent"
    swords-king "a mature man, authoratative, assertive"
    coins-page "scholarship, good news, creativity"
    coins-knight "thoroughness, dependability, good news"
    coins-queen "practicality, shrewdness, financial help"
    coins-king "reliability, success, security"
}

array set reversedKeywords {
    0-fool "recklessness, irresponsibility"
    i-magician "lack of confidence, bad communication"
    ii-papess "suppressed feelings, unrecognized potential"
    iii-empress "insecurity, domestic problems"
    iiii-emperor "inferiority, restriction by rules"
    v-pope "bad advice, misinformation"
    vi-lovers "indecision, bad decision"
    vii-chariot "aimlessness, selfishness, inner conflict"
    viii-justice "injustice, bias"
    viiii-hermit "loneliness, exclusion"
    x-wheel "misfortune, pessimism"
    xi-strength "helpless feelings, inhibition"
    xii-hanged "dissatisfaction, apathy"
    xiii-death "traumatic change, delayed change"
    xiiii-temperance "moodiness, uncertainty"
    xv-devil "intolerable situation, escape"
    xvi-tower "preventable misfortune, disappointing blow" 
    xvii-star "hope, delayed fulfilment"
    xviii-moon "fears, phobias, despair"
    xviiii-sun "daydreaming, disillusionment"
    xx-judgement "regret, remorse, unsatisfactory outcome"
    xxi-world "recurring problems, delayed completion"
    coins-ace "insecurity, materialism"
    coins-2 "moodiness, fluctuation, silliness"
    coins-3 "unrewarding work"
    coins-4 "posessiveness, miserliness"
    coins-5 "poverty, unemployment, destitution"
    cups-ace "sadness, lonliness, disappointment"
    cups-2 "quarrels, separation, divorce"
    cups-3 "selfishness, exploitation, domestic problems"
    cups-4 "self-indulgence, depression"
    cups-5 "loss, remorse, sadness"
    swords-ace "cruelty, injustice"
    swords-2 "conflict, difference of opinion"
    swords-3 "prolonged conflict, pain, destruction"
    swords-4 "banishment, rejection, escape"
    swords-5 "humiliation, bullying, deception"
    wands-ace "wasted energy"
    wands-2 "indecision, disillusionment, anticlimax"
    wands-3 "procrastination, missed opportunities, unrealistic desires"
    wands-4 "restriction, regulations"
    wands-5 "rivalry, squabbling, disruption"
    wands-6 "anticlimax, delayed success"
    cups-6 "unhappy memories, nostalgia"
    swords-6 "temporary improvement"
    coins-6 "theft, being cheated or used"
    wands-7 "failure to meet a challenge, lacking confidence"
    cups-7 "delusion, fantasy, bewilderment"
    swords-7 "timidity, conservative behaviour"
    coins-7 "despondency, failure, abandonment"
    wands-8 "haste, disorganization, exhaustion"
    cups-8 "abandoned success"
    swords-8 "great restriction, need for change"
    coins-8 "short-term gains, expediency"
    wands-9 "obstinancy, futile persistence"
    cups-9 "complacency, superficiality"
    swords-9 "severe depression, cruelty, morbid fantasies"
    coins-9 "illusory security, dependence"
    wands-ten "oppresive burden, overwork"
    cups-ten "disrupted happines, disgruntled individual"
    swords-ten "false hope, continuing misfortune, ruin"
    coins-ten "family problems, social responsibility"
    wands-page "a complainer; a faithless lover; bad news"
    wands-knight "a jealous person, argumentative, aggressive"
    wands-queen "a possessive woman; bad-tempered, dictatorial"
    wands-king "an intolerant, bigoted man; violent, bad advice"
    cups-page "a trivial and spoiled person; a manipulator"
    cups-knight "an idle swindler, a false lover; a lover going away"
    cups-queen "a vain and immoral woman, deceitful and peverse"
    cups-king "a crafty and hot-tempered man; mislead impression"
    swords-page "cunning, underhand dealings"
    swords-knight "aggression, blundering, impersonal force"
    swords-queen "misanthrope, hypercritical, malicious"
    swords-king "bully, exploitation, confrontation"
    coins-page "idlensss, pettiness, money problems"
    coins-knight "timid nature, stagnation, new approaches"
    coins-queen "materialism, insecurity, conflict"
    coins-king "insensitive, overly materialistic"
}

# Links to the Queen of Pentacles Tarot site.
set qopUri http://www.queenofpentacles.com/lessons
array set qopLinks {
    iiii-emperor major/emperor
    vi-lovers major/lovers
    xi-strength major/strength
    x-wheel major/fortune
    xiiii-temperance major/temperance
    wands-ace minor/wands_01
    wands-6 minor/wands_06
    wands-8 minor/wands_08
    cups-10 minor/cups_10
    cups-page minor/cups_page
    swords-5 minor/swords_05
    swords-6 minor/swords_06
    coins-2 minor/pent_02
    coins-queen minor/pent_Q
}

# http://www.aeclectic.com/tarot/basics/XXXX.html
set thirteenUri http://www.aeclectic.net/tarot/basics
foreach cardName [array names uprightKeywords] {
    if {[regexp "^\[0ivx\]+-(\[a-z\]+)\$" $cardName dummy shortName]} {
	set thirteenLinks($cardName) $shortName
    }
}
foreach {myNum hisNum} {ace aces 2 twos 3 threes 4 fours 5 fives \
	6 sixes 7 sevens 8 eights 9 nines ten tens \
	page pages knight knights queen queens king kings} {
    foreach suit {wands cups swords coins} {
	set thirteenLinks($suit-$myNum) $hisNum
    }
}
array set thirteenLinks {
    ii-papess highpriestess
    v-pope hierophant
    ix-hanged hangedman
}



set cardDescs(0-fool) {

    p "The Fool represents a lucky chancer&mdash;happy to take things
    as they come, and not afraid to trust to his fate.  The Fool would
    rather smell the roses than worry too much about the wild animals
    that he wanders amongst or the cliff at his feet or the little dog
    who is trying to warn him to pay attention.  But that&rsquo;s OK,
    at least up to a point."

    p "When the Major Arcana are viewed as a journey from ignorance to
    wisdom, the Fool represents the start of the journey (or of a new
    journey, or a new cycle).  The pack can be interpreted as
    spiritual baggage (or past karma) of which the Fool is not
    consciously aware.  "

    p " The jester&rsquo;s hat stands in for motley (which does not
    show up very will in stick figures!).   The Fool is sometimes drawn
    as a beggar&mdash;both of these occupations are ones where you own
    little and have no responsibilities."

    p "The Fool is the only Major Arcana card to survive to the modern
    playing-card deck."
}

set cardDescs(i-magician) {

    p " If the Fool represents blissful ignorance, the Magician (or
    Conjourer) represents skill and cleverness.  "

    p "In modern decks he is shown with an &lsquo;infinity&rsquo; halo
    and the objects of the table before him are the four suits
    (representing mastery over the four elements).  I&nbsp;have
    followed this tradition but given him both a pointy
    wizards&rsquo;s hat (referring to the magical interpretation) and
    a rabbit and top hat (referring to the conjourer interpretation).
    The rabbit-from-the-hat trick also stands for showy skills that
    are not actually particularly useful&mdash;cleverness as opposed
    to wisdom.  After all, the Magician is more skilled than the Fool,
    but has not advanced all that much through the journey of the
    Arcana.
"
}


set cardDescs(ii-papess) {

    p " Old Italian tarot decks had a Pope and Papess (female Pope)
    rather than Hierophant and High Priestess, and I&nbsp;have
    followed suit.  To mediaeval Italians, the Pope represented
    religious authority,  and if representing the Pope in a deck
    of cards is cheeky, the Papess is downright subersive&mdash;a
    definite dig at the Establishment.  This is consitent with the
    origin of the Tarot deck as a gambling or gaming deck.  "

    p " Nowadays we think of the Pope (Hierophant) as representing an
    advisor, not necessarily on spiritual and religious matters; the
    Papess can be read as standing for going outside regular channels,
    following one&rsquo;s intuition, finding one&rsquo;s own spiritual
    path.  The High Priestess represents the same idea, but within the
    System rather than subverting it.  This is a reflection of the
    idea that mystery and the hidden are an essential part of life,
    rather than an exception to the rule.  "

    p " In this aspect the card is also known as Juno (the most most
    powerful of the Roman godesses, governing marriage, and identified
    with the Greek goddess Hera).  The connection is with the
    Women&rsquo;s Mysteries of the classical world."

    p "The Papess sits between two pillars I&nbsp;have labelled Alpha
    and Omega (sometimes Cabalistically called Boaz and Jachin after

    [a http://www.queenofpentacles.com/articles/boaz_jachin.html "the
    two pillars in front of Solomon&rsquo;s temple in the Bible"]).
    They are coloured black and white representing female and male
    principles, the same colours used in the 

    [a http://chinesefortunecalendar.com/yinyang.htm "Chinese Yin-Yang
    symbol"].  The Alpha and Omega suggest that everything (or all
    personalities) combines these masculine and feminine traits.  Or
    perhaps the Omega is there to allude to a biological analogy
    between the white male pillar and phallus... "
}

set cardDescs(iii-empress) {
    
    p " The Empress is here associated with Demeter or Ceres (goddess
    of fertility and the seasons).  The bounty of nature is
    represented through civilized symbols: the grain and fruit she
    carries and the cow in the background represent cultivation and
    animal husbandry; the rolling hills are the result of agriculture
    rather than erosion.  To a mediaeval person, surrounded by
    dangerous forests and barren mountains, a tilled field is more
    attractive than a natural wilderness: enjoying the scenery is a
    luxury reserved for people who are no longer threatened by it.  "

    p "Where the Papess represents female spirituality (which the
    ancients saw as mysterious and scary), the Empress stands for a
    feminine aspect of temporal authority&mdash;and in mediaeval
    times, women were in charge of food, hearth and home&mdash;and not
    much else."

    p "In magical tradition, the Empress is also the first authority
    figure in the body&ndash;mind&ndash;spirit ensemble."

    p "It is a little hard to see this in 2D, but my Empress&rsquo;s
    crown has 12 red stones (five of them are on side of her head you
    can&rsquo;t see) and four of those round stones in the pointy bits
    (one of them is hidden).  Together with the Zodiac symbols on her
    dress, these symbolize the annual cycle of the seasons.  Red
    flowers and the red in her dress traditionally represent menstrual
    blood; the waterfall and the blue in her dress are another symbol
    of fertility."

}

set cardDescs(v-pope) {

    p "At the time the tarot decks were first devised (Italy around
    the 14th or 15th century), the Pope was a fact of life and a
    figure of religious and social authority&mdash;in those days
    religion defined society in a way we cannot really imagine today.
    This card stands for the institutions and authorities of society.
    It also symbolizes spiritual or religious teaching or advice, or,
    more loosely, professional advice in general (such as from your
    soliciter).  In modern decks this card has been renamed The
    Hieriphant, a reference to a professional religious advisor in
    classical times."

    p "In magical tradition, the Pope is also the third authority
    figure in the body&ndash;mind&ndash;spirit ensemble."

    p "In my Alleged Tarot I&nbsp;have used the older names for some
    of the cards.  The reason for this is that my original Pebble
    Tarot was based on the tarot deck I&nbsp;had at the time&mdash;the

    [a http://www.aeclectic.net/tarot/1jjswiss/index.html "1JJ Swiss tarot"], 

    and that uses the old card names.  My Pope was
    the most popular card amongst my friends, and if I&nbsp;wanted to
    retain the Pope it followed I&nbsp;would be using the old names
    for the other cards too.  You can tell he&rsquo;s the Pope because
    he has a fancy hat and a kissable ring.  He is also making the
    mystic hand signal which means &lsquo;as above (in the spirit
    world), so below (in the material world)&rsquo;.  The Hierophant
    is often decorated with a pentacle; I&nbsp;have alluded to that in
    the five-pointed star on his Pope hat.  "
    
}


set cardDescs(vi-lovers) {
    
    p "In modern decks, this card shows a couple
    embracing.  I&nbsp;have followed an older tradition showing suitor
    apparently choosing between two women.  This card represents
    choice, the sort of choice where both alternatives are attractive
    and one must be abandoned forever.  This reflects a reality of
    mediaeval life, which is that your choice of lover is significant
    (think doweries and family alliances) and irrevocable in a way it
    is not in modern times."

    p "To emphasize the choice aspect I show the two women standing on
    different branches of a forked path.  The vaguely Victorian
    clothing is the result of my whimsical decision around the time
    I&nbsp;was drawing the Magician that the trumps would all be
    wearing hats of some sort.  When it came to dressing a suitor, a
    top hat just seemed appropriate."
}


set cardDescs(vii-chariot) {

    p "The chariot card shows a chariot drawn by two horses (or
    fabulous beasts if you prefer a more magical look).  The person in
    the chariot is often shown armoured and without reins&mdash;the
    beasts are controlled by the will.  Like the pillars in the
    picture of the Papess, the beasts are coloured black and white to
    represent the mysterious female principle and the transparent male
    principle.  The figure in the chariot represents our sense of self
    or will, which must guide the course of the chariot no matter how
    the much the two horses want to take over and gallop off in random
    directions.  Apparently this illustration of the will versus our
    baser natures goes all the way back to Plato.  It can also be
    interpreted in terms of Freud&rsquo;s model (the superego
    controlling the id and ego, or however it is supposed to work).  "

    p "The helmet my charioteer is wearing is not from any particular
    historical period, although the chariot itself looks reasonably
    Roman or Greek.  For no particular reason I&nbsp;have identified
    the chariot with Apollo&rsquo;s (if the giant sun background is
    anything to go by).  Since Apollo is god of reason
    and self-discipline, perhaps this is appropriate."
}

set cardDescs(viii-justice) {

    p "You may have expected trump card number VIII to be Strength,
    because in the Rider&ndash;Waite these two cards were transposed
    to make the order better suit the zodiac signs attributed to the
    cards by the Golden Dawn.  Their reordering of the trumps is not
    as arbitrary as it might sound at first; the oldest known tarot
    decks used unnumbered cards (the order of the trumps was either
    self-evident or irrelevant), and it is not too much of a stretch
    to claim that when the numbered decks were first printed, slight
    errors were made.  On the other hand, my virtual deck tends
    whimsically to be modelled on the older decks, and so I&nbsp;have
    followed the older numbering. "
    
    p "Justice and other abstract concepts have been depicted as women
    since Classical times because in Greek abstract nouns have the
    feminine gender.  "

    p "My depiction of Justice sans blindfold is also a self-conscious
    archaism: the blindfold is a relatively recent addition to the
    traditional props of the personification of Justice.  I&nbsp;stood
    her on a roof-top because I&nbsp;was thinking of the famous statue
    of Justice standing atop the Old Bailey in London.  This also
    allows my version of justice to search out wrong-doers and take a
    long view unobstructed by personal bias.
"
}

set cardDescs(xi-strength) {
    
    p "In some decks this is card VIII&mdash;a modification designed
    to make the tarot deck better match the order of the signs of the
    zodiac (since Leo preceeds Libra in the zodiac).  If you see the
    trumps as a progression through life, then it is nice that
    strength of mind preceeds the application of justice.  Of course
    the oldest known tarot decks use unnumbered cards; for their owners
    the order of the trumps was either self-evident or irrelevant.  "

    p " Having reverted to an older ordering, I&nbsp;did not use the
    older name, Fortitude, even though this might better suggest the
    significance of the card, which relates to strength of will or
    moral strength, rather than physical strength.  The woman holding
    the jaws of a lion is the traditional personification of
    Fortitude (one of Plato&rsquo;s cardinal virtues); the lion is her
    traditional prop just as the scales are Justice&rsquo;s and wings
    and two jars are of Temperance.  (The fourth cardinal virtue,
    Prudence, is not represented in the tarot deck.)  "

    p " The lion can be seen as representing powerful emotional or
    physical feelings that one must direct to creative ends; both
    complete suppression and a free rein  lead to bad outcomes."
}


set cardDescs(xiiii-temperance) {

    p "Temperance is one of the four Cardinal Virtues of Plato,
    together with Strength (Fortitude), Justice and Prudence (the last
    of which does not have a Tarot card). It means the combination of
    elements to make a stronger, more balanced whole&mdash;as in wine
    tempered with water (standard practice in Classical times), or phrases
    like justice tempered with mercy.  So this card is about finding
    balance, and giving everything its measure. "

    p "Abstract nouns are personified as women, a tradition that goes
back to ancient Greece (since abstract nouns happen to have the
feminine gender in that language).  The wings are also traditional,
even though Temperance is not intended to be seen as an angel in the
Christian sense.  The vessels she is holding are often coloured gold
(suggesting the sun) and silver (suggesting the moon), an allusion to
the idea that a healthy psyche is a mixture of feminine and masculine
traits&mdash;or to the mystical theory that all reality is defined by
feminine and masculine principles."

    p "I have alluded to the latter interpretation by incorporating a
monad (yin-yang symbol) in to the face of my sketchy temple.  It is
further represented by the inclusion of children playing on a seesaw
in the background."


}

set cardDescs(xv-devil) {

    p "Naturally the trumps includes a card for the Devil&mdash;like the Pope and Death, for the mediaeval European, the Devil was a fact of life, and the recurring villain in any number of folk tales and hearthside stories.  Nevertheless the depiction of devils makes some people nervous.  In more modern decks, this card  is sometimes replaced with a picture of the Horned Man, a pagan god of fertility and nature&mdash;even though the interpretation of the card remains broadly the same."

    p "The Devil card represents anger and resentment, and being trapped in a bad situation that you cannot escape (like the figures chained to the Devil&rsquo;s plinth).  "

    p "In my version of the card I&nbsp;omitted the plinth, so the
chains of the the two figures at the bottom of the card are held by
the devil himself.  "

}


set cardDescs(wands-ace) {

    p "Wands stand for work in the sense of enthusiasm, creative
    labour and organization.  This made sense to me when
    I&nbsp;thought of wands as suggesting various sorts of tool.  The
    Ace of Wands often represents beginnings and new enterprises. "

    p "The suit of Wands is also associated with the element of fire,
    which is why I&nbsp;have given this card a fiery background.  The
    little sprig of leaves at the bottom of the wand serves two
    purposes: it symbolizes new beginnings (as this is an Ace), and it
    reminds us of the suit of Clubs in modern playing cards.  (Older
    decks tend to draw the Wands as more literally club-like.)"

}

set cardDescs(wands-2) { 

    p "The Ace of Wands symbolizes the beginning of a new enterprise;
    the Two can mean you are thinking about how to take the next
    step&mdash;a time for assessing the progress so far and deciding
    which path to take to success.  The suit often refers to
    one&rsquo;s work or career, so the next &lsquo;step&rsquo; might
    be a promotion, perhaps with an element of self-doubt as you
    consider whether you can cope with the new responsibilities.  It
    can also symbolize other personal aims and ambitions."

    p "I&nbsp;have symbolized the decision as a fork in the road.  The
    path behind the figure shows the progress made already.  The
    early-morning sky shows that the journey has just started.  "

}

set cardDescs(wands-3) {

    p "The number three symbolizes creation (think 2 parents plus one
    child), divinity (think of the Christian Trinity, Burton&rsquo;s
    Triple Goddess, the Fates, the Norns) and luck.  It also
    represents a progression beyond the ideas symbolized by the number
    two, especially in the suit of Wands, which often represents
    career progression, creative energy and your personal journey
    through life.  The Three of Wands therefore can mean the
    successful start of a project (the sequel to the Two), or making
    plans for a grand project (the creativity sense of the number 3),
    and waiting to see how they turn out (with some optimisim, because
    3 is lucky)."
    
}

set cardDescs(wands-4) {

    p "The number 4 represents stability and completion&mdash;think of
    the four elements, the four corners of the earth, the four
    seasons. It thus stands for stability (as in
    &lsquo;foursquare&rsquo;). Combined with the creative intellectual
    energy of the suit of Wands, this gives a calm and creative
    environment where inspiration may be freely expressed. It may
    represent an actual place, or an event (like a holiday)."

    p "Four wands standing in a square define a room, so I&nbsp;have
    illustrated this card with an artist&rsquo;s studio.  The
    fire-place shows it is cozy and comfortable&mdash;and links us to
    the element of fire (associated with this tarot suit).  The fours
    usually indicate a an [em ordered] environment; in a studio this
    order is often invisible to the casual observer, who sees the
    clutter of brushes, tubes of paint, and pictures piled around as
    chaotic, and does not understand the organization that the owner
    of the studio does.  "

}

set cardDescs(wands-5) {
    
    p "After the stability of 4, the number 5 represents disruption
    and discord; to Discordians, it is Eris&rsquo;s own number.  The
    fives are generaly inauspicious cards in tarot, but when balanced
    against with the positive, creative energy of the suit of Wands,
    the 5 isn&rsquo;t as bad as all that.  It represents a problem or
    set-back, but nothing beyond what one&rsquo;s resourcefulness
    cannot deal with.  In fact, it may even be welcomed as break from
    the norm, or chance to demonstrate one&rsquo;s mastery of the
    situation. "

    p "I&nbsp;have illustrated this card with a cyclist repairing a
    puncture&mdash;thus while his journey is interrupted, the
    interruption is short-lived, because he as the tools he needs to
    repair the damage."
}


set cardDescs(cups-ace) {

    p "Cups relate to the element of Water in an obvious way and are
    as feminine in shape in the same way swords and wands are phallic.
    The suit of Cups is largely associated with home life, domestic
    relations, love, sensitivity, and emotions, which I&nbsp;have
    alluded to by making my cup a tea cup with tea in it.  Cups also
    represents artistic inspiration and the subconscious mind.  "

    p "The Ace of Cups often represents a warm, loving, empathetic
    person.  The heart on the side also relates to this emotional
    sense, and also to the correspondence between Cups and the modern
    suit of Hearts. "
}

set cardDescs(cups-2) {

    p "The suit of Cups relates to life, domestic relations, love, and
    emotion.  The Two of Cups thus represents a relationship between
    two people&mdash;this might be friendship, an affair or marriage.
    It does not have to be literally a love affair&mdash;it might
    relate to a business partnership or other collaboration, with
    trust and support on both sides."

    p "In drawing the Twos cards I used a single figure for Coins and
    Wands, female for Coins and male for Wands (their triaditional
    gender associations).  For Cups and Swords I&nbsp;used two
    figures, because these suits are the the more archetypically
    feminine and masculine.  Thus this card shows two women who are
    apparently embarking on a domestic arrangement of some
    sort&mdash;symbolized by looking at cups in a shop window."
}

set cardDescs(cups-3) {
 
    p "The number 3 represents creativity and creation, and combined
    with the watery, emotional suit of cups, this means a birth,
    literal or figurative (as in emotional or creative growth).  Three
    is a lucky number, and so this card also suggests a happy family
    life and good fourtune in matters of the heart."

    p "My glowing baby stick-figure is supposed to evoke 

    [a http://keithharing.com/ "Keith Haring"]&rsquo;s 

    [a http://keithharing.com/art/cards/cards/classic_f10.gif "glowing baby"]
pictures.  "
}

set cardDescs(cups-4) {
    
    p "The number 4 represents stability and solidity.  Combined with
    the suit of cups (traditionally considered to be feminine and
    therefore traditionally considered passive), this leads to an
    overplus of stability, veering in to stagnation and boredom."

    p "All my Cups cards have a blue aspect (suggesting water), and in
    this one it dominates to give the whole picture a static look.  At
    one point I&nbsp;considered adding props in the foreground to
    suggest carnal satiation but in the end a paper dart and some
    discarded magazines sufficed."
}


set cardDescs(swords-ace) {

    p "Nowadays the literally martial aspect of our lives is, happily,
    less important for many of us than it was in mediaeval times, so
    the meaning of the suit of Swords is interpreted more broadly.
    Swords straightforwardly represent strife, conflict and
    destruction.  Justice and the courts were functions of the milita,
    so Swords represents justice and judicial proceedings.  Warfare
    required strategy and analysis, so Swords also represents abstract
    thought and rationality, especially in a reductionist sense."

    p "The background reminds us that the suit of Swords is associated
    with the element of Air.  I have shown the symbol of the modern
    suit of Spades engraved on the blade."
}

set cardDescs(swords-2) { 

    p "Swords represent military matters: strife, judicial matters,
    strategy and abstract thought.  Twos represent combination of or
    balance between two forces.  So the Two of Swords often represents
    opposing forces that have met in a (temporary) stalemate, truce,
    or impass. These can be internal states, like the knowledge that
    something must be done, versus reluctance to actually do it. It
    can also mean two forces or people in conflict that could work
    together given the right insight."
}


set cardDescs(coins-ace) {
    
    p "Coins stand for the financial and commercial side of life (that
    is, money).  Coins also stands for the element of Earth,
    symbolizing physical feelings, practical skills, fertility and
    solidity.  The Ace of Coins represents security, both finanical
    and in the sense of feeling secure and healthy.  It also alludes
    to enjoying physical pleasures such as eating.  My coin is
    decorated with a Diamond shape to remind us of its corresponding
    suit in modern playing cards."
}

set cardDescs(wands-queen) {
    p " The chair is based on Charles Rennie Mackintosh&rsquo;s chair
design for the Argyle Street Tea Rooms, 1897.  I chose it because its
tall and narrow shape and oak construction suggests the suit of Wands
to me.  The shape of the headrest makes it slightly more
&lsquo;feminine&rsquo; in shape than the one I&nbsp;gave to the
King. I have exaggerated its size to make it ore like a throne than a normal chair."
 }

set cardDescs(wands-king) {
    p "The chair is another Charles Rennie Mackintosh design from the
early years of the twentieth century, listed as 
House for an Art Lover Carver
Chair.  (I&nbsp;dont&rsquo;t have the exact date because I&nbsp;found
it in a modern furniture catalogue!)  "

 }


set cardDescs(cups-queen) {
    p "The chair is the Ball (of Globe) chair, designed by Eero Aarnio
around 1963&ndash;65.  I&nbsp;chose it because of its shape&mdash;it
is one of the most cup-like famous chair designs, so particularly
appropriate to this, the most feminine of Cups cards (the Queens and
the suit of Cups both being the associated with the feminine element
of water)."  

}

set cardDescs(cups-king) {
    p "The chair I have give the King of Cups is (based on) the Egg chair, designed by Arne Jacobsen for the SAS Hotel in 1957&ndash;58.  It seemed appropriate given its organic shape, which is cup-like but taller and less padded than the Globe (which I used for the Queen), which suits the King.
The Egg chair was also used by Dr No in the James Bond film of the same name."
}

set cardDescs(swords-queen) {
    p "
The scales, water jug and photograph are supposed to symbolize the three zodiac signs associated with the suit of Swords (Libra, Aquarius, and Gemini).  Why exactly Aquarius is an air sign is beyond me.  The book represents knowlege and intellectual pursuits.  Her crown is decorated with the symbol of the suit os spades, the modern equivalent of the tarot suit of swords.
"
    p "The chair is based on one designed by Otto Wagner for the &lsquo;Die Zeit&rsquo; telegraph office, 1902."

}

set cardDescs(swords-king) {
    p "
    The symbols in the background are of course those of the three zodiac signs associated with this suit.  
"

p "The King&rsquo;s chair is a stick-figure version of the 
[a http://www.hermanmiller.com/CDA/product/0,1469,c201-pss1-p8,00.html Aeron],
designed by Donald Chadwick and William Stumpf in 1992.  As well as
having a name suggestive of air, the Aristotlian element associated
the suit of Swords, the Aeron was one of the potent symbols of the
information-technology boom of the late 1990s (and the sale of Aerons
on E-bay was one of the potent symbols of the dot-com collapse in the
early 2000s)&mdash;and the suit of Swords governs intellectual
activity.  "

}

set cardDescs(coins-queen) {

    p "The queen&rsquo;s chair here is based on the Womb chair, model
70, designed by Eero Saarinen in 1947&ndash;48.  I was looking for
something broad in shape (suggesting the solidity of the element of
earth), organic and enclosing in shape (though not as cup-like as the
Queen of Cups&rsquo;s Globe)."

}

set cardDescs(coins-king) {

p " The king&rsquo;s chair is the Grand Confort, Model N&ordm; LC2,
designed in 1928 by LeCorbusier, Pierre Jenneret, and Charlotte
Perriand.  I chose it largely because of its shape&mdash;square,
almost cubical, which suggests the element of earth.
"

}
