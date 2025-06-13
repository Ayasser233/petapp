import 'package:flutter/material.dart';

/// Data model for a symptom
class PetSymptom {
  final String name;
  final String description;
  final List<String> causes;
  final List<String> actions;
  
  const PetSymptom({
    required this.name,
    required this.description,
    required this.causes,
    required this.actions,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'causes': causes,
      'actions': actions,
    };
  }
}

/// Organized symptom data by body parts and categories
class PetSymptomData {
  /// Get icon for a specific symptom category
  static IconData getCategoryIcon(String category) {
  switch (category) {
    case 'Eye Symptoms':
      return Icons.visibility;
    case 'Ear Symptoms':
      return Icons.hearing;
    case 'Mouth & Teeth Symptoms':
      return Icons.masks;
    case 'Skin & Coat Symptoms':
      return Icons.texture;
    case 'Movement & Limbs Issues':
      return Icons.directions_walk;
    case 'Digestive Problems':
      return Icons.restaurant;
    case 'Anus & Pooping Issues':
      return Icons.circle_outlined;
    case 'Male Genital Problems':
      return Icons.male;
    case 'Female Genital Problems':
      return Icons.female;
    case 'Urination Problems':
      return Icons.water_drop;
    case 'General':
    default:
      return Icons.medical_services;
  }
}
  
  /// Get icon for a specific symptom based on its name
  static IconData getSymptomIcon(String symptomName) {
  // Existing eye, ear, mouth symptoms
  if (symptomName.contains('Eye')) return Icons.remove_red_eye;
  if (symptomName.contains('Ear')) return Icons.hearing;
  if (symptomName.contains('Teeth') || symptomName.contains('Mouth')) return Icons.masks;
  if (symptomName.contains('Breath')) return Icons.air;
  if (symptomName.contains('Drool')) return Icons.water_drop;
  
  // Existing general symptoms
  if (symptomName.contains('Pain')) return Icons.healing;
  if (symptomName.contains('Swelling') || symptomName.contains('Swollen')) return Icons.sick;
  if (symptomName.contains('Bleeding')) return Icons.bloodtype;
  
  // Skin & coat symptoms
  if (symptomName.contains('Hair Loss') || symptomName.contains('Bald')) return Icons.content_cut;
  if (symptomName.contains('Itch') || symptomName.contains('Scratch')) return Icons.back_hand;
  if (symptomName.contains('Red') || symptomName.contains('Inflam')) return Icons.local_fire_department;
  if (symptomName.contains('Dandruff') || symptomName.contains('Flaky')) return Icons.ac_unit;
  if (symptomName.contains('Oil') || symptomName.contains('Grease')) return Icons.opacity;
  if (symptomName.contains('Crust')) return Icons.healing;
  if (symptomName.contains('Lump') || symptomName.contains('Bump')) return Icons.circle;
  if (symptomName.contains('Dark') || symptomName.contains('Pigment')) return Icons.brightness_2;
  
  // Movement & limbs symptoms
  if (symptomName.contains('Limp')) return Icons.directions_walk;
  if (symptomName.contains('Stiff')) return Icons.accessibility_new;
  if (symptomName.contains('Weak') || symptomName.contains('Collaps')) return Icons.airline_seat_flat;
  if (symptomName.contains('Trembl') || symptomName.contains('Shak')) return Icons.vibration;
  
  // Digestive symptoms (abdomen)
  if (symptomName.contains('Diarrhea')) return Icons.water;
  if (symptomName.contains('Constipation')) return Icons.block;
  if (symptomName.contains('Bloody Poop')) return Icons.bloodtype;
  if (symptomName.contains('Mucus')) return Icons.bubble_chart;
  if (symptomName.contains('Pooping Too Much')) return Icons.repeat;
  if (symptomName.contains('No Pooping')) return Icons.do_not_disturb;
  
  // Anus symptoms
  if (symptomName.contains('Scoot')) return Icons.swipe;
  if (symptomName.contains('Anal')) return Icons.circle_outlined;
  
  // Male genital symptoms
  if (symptomName.contains('Testicle')) return Icons.album;
  if (symptomName.contains('Penis')) return Icons.linear_scale;
  if (symptomName.contains('Missing')) return Icons.not_interested;
  
  // Female genital symptoms
  if (symptomName.contains('Vulva')) return Icons.spa;
  if (symptomName.contains('Discharge')) return Icons.opacity;
  if (symptomName.contains('Licking')) return Icons.cleaning_services;
  if (symptomName.contains('Prolapse') || symptomName.contains('Sticking Out')) return Icons.arrow_outward;
  
  // Urination symptoms
  if (symptomName.contains('Pee')) return Icons.water_drop;
  if (symptomName.contains('Urinat')) return Icons.water_drop;
  if (symptomName.contains('Leaking')) return Icons.invert_colors;
  
  // Default icon
  return Icons.medical_services;
}
  
  /// Get icon for a body part
  static IconData getBodyPartIcon(String bodyPart) {
  switch (bodyPart) {
    case 'head':
      return Icons.face;
    case 'chest':
      return Icons.favorite;
    case 'abdomen':
      return Icons.restaurant;
    case 'legs':
      return Icons.directions_walk;
    case 'tail':
      return Icons.pets;
    case 'skin':
      return Icons.texture;
    case 'pelvis':  // New category
      return Icons.people;
    case 'buttocks':  // New category
      return Icons.circle_outlined;
    default:
      return Icons.pets;
  }
}
  
  /// All symptom data organized by body part and category
  static final Map<String, Map<String, List<PetSymptom>>> symptoms = {
    'head': {
      // Head symptoms remain the same
      'Eye Symptoms': [
        const PetSymptom(
          name: 'Eye Redness',
          description: 'Noticed your pet\'s eye looking red? It could be something small like dust or something serious like an infection.',
          causes: [
            'Dust, wind, or allergies',
            'Infection (like bacteria or herpes virus)',
            'High eye pressure (glaucoma)',
            'Injury or irritation'
          ],
          actions: [
            'If mild → Rinse with saline & monitor',
            'If swollen, painful, or squinting → Vet visit ASAP'
          ],
        ),
        const PetSymptom(
          name: 'Eye Discharge',
          description: 'A little eye goop can be normal, but if it\'s thick, yellow, or green, it might mean an infection.',
          causes: [
            'Normal in some breeds (like Persians)',
            'Allergies or mild irritation',
            'Infection (yellow/green goop)',
            'Could be linked to worms in some cases'
          ],
          actions: [
            'If clear or light goop, and your pet seems fine → Wipe it away & monitor',
            'If thick, yellow, or green → Vet check recommended'
          ],
        ),
        const PetSymptom(
          name: 'Cloudy Eye',
          description: 'If your pet\'s eye looks cloudy or milky, it could be a normal age change or something serious.',
          causes: [
            'Older pets: Normal aging (nuclear sclerosis)',
            'Cataracts (can cause blindness)',
            'Corneal ulcers (after injury or infection)',
            'High eye pressure (glaucoma)'
          ],
          actions: [
            'If gradual change in an older pet → Mention at next vet check-up',
            'If sudden cloudiness, pain, or squinting → Vet visit ASAP, delaying can cause blindness'
          ],
        ),
        const PetSymptom(
          name: 'Watery Eyes',
          description: 'Some tearing is normal, but too much can mean an issue.',
          causes: [
            'Allergies or mild irritation',
            'Blocked tear ducts (common in small dogs)',
            'Infection (like feline calicivirus)',
            'Infection or corneal ulcers (if redness & squinting)'
          ],
          actions: [
            'If mild & no other signs → Wipe & monitor',
            'If excessive, with redness or rubbing → Vet check is a good idea'
          ],
        ),
        const PetSymptom(
          name: 'Third Eyelid Showing',
          description: 'If you suddenly see a white or pinkish membrane covering part of your pet\'s eye, don\'t panic! It\'s called the third eyelid.',
          causes: [
            'Normal after waking up',
            'Illness, dehydration, or pain',
            'Eye infection, nerve issues, or Haws Syndrome (cats)',
            'Cherry eye (prolapsed third eyelid gland, common in some dog breeds)'
          ],
          actions: [
            'If it goes away quickly & your pet acts normal → No concern',
            'If it stays visible, or your pet seems sick → Vet visit recommended'
          ],
        ),
        const PetSymptom(
          name: 'Squinting or Keeping Eye Closed',
          description: 'If your pet keeps one eye closed or blinks a lot, they might be in pain.',
          causes: [
            'Irritation from dust or hair',
            'Corneal ulcer (scratch on the eye)',
            'Infection or high eye pressure'
          ],
          actions: [
            'If mild & improves quickly → Monitor & rinse with saline',
            'If ongoing squinting or rubbing → Vet visit ASAP'
          ],
        ),
        const PetSymptom(
          name: 'Swelling Around the Eye',
          description: 'If your pet\'s eye looks puffy or swollen, something is irritating it.',
          causes: [
            'Allergy or mild irritation',
            'Infection or injury',
            'Abscess or tumor (rare but possible)'
          ],
          actions: [
            'If mild swelling & no other symptoms → Cold compress & monitor',
            'If severe swelling, pain, or redness → Vet visit ASAP'
          ],
        ),
        const PetSymptom(
          name: 'Bulging Eye',
          description: 'If one eye suddenly looks bigger than the other, this is an emergency!',
          causes: [
            'Glaucoma (high eye pressure)',
            'Eye injury or bleeding behind the eye',
            'Infection or tumor behind the eye'
          ],
          actions: [
            'Vet visit ASAP! Delaying treatment can cause blindness'
          ],
        ),
      ],
      'Ear Symptoms': [
        const PetSymptom(
          name: 'Itchy Ears',
          description: 'If your pet is shaking their head like a mini rockstar or scratching their ears a lot, something is bugging them!',
          causes: [
            'Ear infection (bacteria or yeast)',
            'Ear mites (tiny bugs, common in cats)',
            'Allergies (food or environmental)',
            'Something stuck inside (grass, dirt)'
          ],
          actions: [
            'If mild & ears look normal → Wipe gently & monitor',
            'If redness, swelling, or bad smell → Vet visit needed',
            'If shaking a lot → Act fast! Too much shaking can cause an ear hematoma'
          ],
        ),
        const PetSymptom(
          name: 'Black Stuff in the Ear',
          description: 'Noticed dark gunk in your pet\'s ears? It could be harmless wax or a sign of mites or infection!',
          causes: [
            'Normal wax (small amounts, no smell)',
            'Ear mites (coffee-ground-like debris, very itchy)',
            'Yeast or bacterial infection (smelly, moist)'
          ],
          actions: [
            'If small amounts & no scratching → Clean gently',
            'If itchy, smelly, or a lot of black debris → Vet check recommended'
          ],
        ),
        const PetSymptom(
          name: 'Ear Wax Buildup',
          description: 'Some pets naturally have more ear wax. But if it looks like a lot, it might be a problem.',
          causes: [
            'Normal variation between pets',
            'Ear infection (bacteria or yeast)',
            'Allergies (food or environmental)',
            'Ear mites (common in cats)'
          ],
          actions: [
            'If no other symptoms & not excessive → Just clean during baths',
            'If excessive, smelly, or your pet is shaking their head → Vet check recommended'
          ],
        ),
        const PetSymptom(
          name: 'Foul Smell from Ears',
          description: 'A bad smell coming from your pet\'s ears can be a sign of infection or other issues.',
          causes: [
            'Ear infection (bacteria or yeast)',
            'Ear mites (common in cats)',
            'Allergies (food or environmental)',
            'Foreign body (like a grass seed)'
          ],
          actions: [
            'If mild smell & no other symptoms → Monitor for a few days',
            'If smell persists or worsens, or if your pet is shaking their head → Vet visit recommended'
          ],
        ),
        const PetSymptom(
          name: 'Head Tilt',
          description: 'If your pet is tilting their head to one side, it could be a sign of an ear problem or other issues.',
          causes: [
            'Ear infection (bacteria or yeast)',
            'Ear mites (common in cats)',
            'Vestibular disease (affects balance)',
            'Neurological issues'
          ],
          actions: [
            'If occasional & no other symptoms → Monitor',
            'If persistent, or if your pet seems disoriented or has other symptoms → Vet visit ASAP'
          ],
        ),
        const PetSymptom(
          name: 'Loss of Balance',
          description: 'If your pet is stumbling, falling, or seems dizzy, it could be a sign of a serious issue.',
          causes: [
            'Inner ear infection (affects balance)',
            'Neurological issues',
            'Toxins (like certain plants or chemicals)',
            'Trauma or injury'
          ],
          actions: [
            'This could be serious → Vet visit ASAP',
            'Keep your pet safe and calm while transporting'
          ],
        ),
      ],
      'Mouth & Teeth Symptoms': [
        const PetSymptom(
          name: 'Bad Breath',
          description: 'If your pet\'s kisses smell like a garbage can, something\'s up!',
          causes: [
            'Dental disease (plaque, gingivitis, or infected teeth)',
            'Something stuck (food, hair, or a foreign object)',
            'Kidney or liver problems (if breath smells like urine or really bad)'
          ],
          actions: [
            'If mild smell → Try brushing with pet-safe toothpaste',
            'If strong smell, red gums, or drooling → Vet check needed',
            'If breath smells like urine or very bad → Could be kidney/liver issue – vet ASAP!'
          ],
        ),
        const PetSymptom(
          name: 'Excessive Drooling',
          description: 'Is your pet drooling more than usual? It could be normal or a sign of a problem.',
          causes: [
            'Normal in some situations (like eating or hot weather)',
            'Dental problems (like gum disease or tooth decay)',
            'Nausea or upset stomach',
            'Poisoning (if drooling is excessive and not normal for your pet)'
          ],
          actions: [
            'If occasional & not excessive → Monitor',
            'If persistent, or if your pet seems lethargic or has other symptoms → Vet visit recommended',
            'If drooling suddenly increases a lot → Vet visit ASAP'
          ],
        ),
        const PetSymptom(
          name: 'Pawing at Mouth',
          description: 'If your pet keeps pawing at their mouth, they might be trying to tell you something\'s wrong.',
          causes: [
            'Dental problems (like a toothache or gum disease)',
            'Something stuck in the mouth or throat',
            'Nausea or upset stomach'
          ],
          actions: [
            'If occasional → Monitor & check for food or debris stuck',
            'If persistent, or if your pet seems in pain or is not eating → Vet visit recommended'
          ],
        ),
        const PetSymptom(
          name: 'Swollen Gums',
          description: 'Gums should be pink and firm, not red, swollen, or bleeding.',
          causes: [
            'Dental disease (plaque, tartar, gingivitis)',
            'Infection',
            'Immune system issues'
          ],
          actions: [
            'If mild swelling & no bleeding → Monitor & maintain dental hygiene',
            'If swelling persists, or if there\'s bleeding or bad breath → Vet visit recommended'
          ],
        ),
        const PetSymptom(
          name: 'Loose or Missing Teeth',
          description: 'Adult pets should have all their teeth. Losing teeth or having loose teeth is not normal.',
          causes: [
            'Dental disease (advanced periodontal disease)',
            'Trauma or injury',
            'Severe infection'
          ],
          actions: [
            'If you notice a tooth is loose or missing → Vet visit ASAP',
            'Dental disease can be painful and affect overall health'
          ],
        ),
      ],
    },
    'chest': {
      // Chest symptoms remain the same
      'General': [
        const PetSymptom(
          name: 'Coughing',
          description: 'Persistent cough that doesn\'t go away',
          causes: [
            'Kennel cough or respiratory infection',
            'Heart disease',
            'Foreign object',
            'Allergies or asthma'
          ],
          actions: [
            'If mild & occasional → Monitor for a few days',
            'If persistent or worsening → Vet visit recommended',
            'If struggling to breathe → Emergency vet visit immediately'
          ],
        ),
        const PetSymptom(
          name: 'Breathing Difficulty',
          description: 'Trouble taking breaths or rapid breathing',
          causes: [
            'Respiratory infection',
            'Heart disease',
            'Asthma',
            'Heatstroke',
            'Pain'
          ],
          actions: [
            'This is usually an emergency → Vet visit ASAP',
            'Keep pet calm and cool while transporting'
          ],
        ),
        const PetSymptom(
          name: 'Chest Pain',
          description: 'Signs of pain when touching the chest area',
          causes: [
            'Injury or trauma',
            'Inflammation',
            'Heart or lung issues'
          ],
          actions: [
            'Vet visit recommended → Could be serious'
          ],
        ),
        const PetSymptom(
          name: 'Heart Issues',
          description: 'Irregular heartbeat or weakness',
          causes: [
            'Heart disease',
            'Congenital heart problems',
            'Age-related changes',
            'Heartworm disease'
          ],
          actions: [
            'Vet visit ASAP → Heart problems need prompt attention'
          ],
        ),
      ]
    },
    'abdomen': {
      // Abdomen symptoms remain the same with digestive issues
      'Digestive Problems': [
        const PetSymptom(
          name: 'Diarrhea',
          description: 'If your pet\'s poop is runny or watery, something might be upsetting their stomach!',
          causes: [
            'Ate something bad (trash, spoiled food, new treats)',
            'Worms or parasites',
            'Infections (from bacteria or viruses)',
            'Food allergies or change in diet',
            'Stress or anxiety',
            'More serious problems (like pancreas or liver issues)'
          ],
          actions: [
            'If diarrhea happens once or twice but your pet is acting normal → Try a bland diet (boiled chicken & rice) and watch for 24 hours',
            'If diarrhea lasts more than a day, has blood, or comes with vomiting/lethargy → Vet visit needed! Could be serious',
            'If your pet is very young, very old, or small breed → Don\'t wait! Diarrhea can cause dehydration fast'
          ],
        ),
        const PetSymptom(
          name: 'Constipation',
          description: 'If your pet is struggling to poop or the stool is very dry, they might be constipated!',
          causes: [
            'Dehydration (not drinking enough water)',
            'Low fiber diet',
            'Swallowing something they shouldn\'t (hair, bones, toys)',
            'Enlarged prostate (in male dogs)',
            'Spinal or nerve issues (common in older pets)'
          ],
          actions: [
            'If mild constipation but your pet is acting normal → Encourage water intake and add some fiber (wet food)',
            'If constipation lasts more than 48 hours → Vet check needed to prevent serious blockage',
            'If straining but no poop comes out at all → Could be a blockage, urgent vet visit!'
          ],
        ),
        const PetSymptom(
          name: 'Bloody Poop',
          description: 'If you see red or black in your pet\'s poop, don\'t ignore it!',
          causes: [
            'Bright red blood → Could be from straining, stomach irritation, or a small injury near the anus',
            'Black, sticky poop → Could be internal bleeding! (stomach or intestines)',
            'Worms, infections, or serious diseases'
          ],
          actions: [
            'If small streaks of red blood but your pet is acting normal → Monitor for 24 hours',
            'If blood is a lot, keeps happening, or pet is weak → Vet visit ASAP!',
            'If poop is black and sticky like old blood → Emergency! Internal bleeding needs immediate vet care!'
          ],
        ),
        const PetSymptom(
          name: 'Mucus in Poop',
          description: 'If your pet\'s poop looks covered in slime, their intestines might be irritated.',
          causes: [
            'Mild irritation from diet changes',
            'Inflamed intestines (can happen from infections or irritation)',
            'Worms or other parasites',
            'Bacteria causing stomach issues'
          ],
          actions: [
            'If it happens once or twice but your pet is acting normal → Might be diet-related, monitor',
            'If mucus keeps appearing or comes with diarrhea/blood → Vet visit recommended',
            'If your pet is also losing weight or vomiting → Could be a serious infection, see a vet!'
          ],
        ),
        const PetSymptom(
          name: 'Pooping Too Much',
          description: 'If your pet is pooping way more than usual, their stomach might be upset!',
          causes: [
            'New diet or food allergies',
            'Mild infections or worms',
            'Stress or excitement',
            'Serious issues – Like long-term stomach problems or diseases'
          ],
          actions: [
            'If your pet recently changed food → Give it a few days to adjust',
            'If pooping more + soft stool → Check when their last deworming was; a vet visit is recommended',
            'If frequent pooping + weight loss or weakness → Vet visit ASAP!'
          ],
        ),
        const PetSymptom(
          name: 'No Pooping At All',
          description: 'If your pet hasn\'t pooped in more than 2 days, they could be blocked!',
          causes: [
            'Severe constipation or something blocking the intestines',
            'Swallowed objects (toys, bones, hair, string)',
            'Nerve issues affecting bowel movement (like spinal problems)'
          ],
          actions: [
            'If no poop for over 48 hours → Vet visit ASAP! Don\'t wait, it could be serious',
            'If your pet is trying to poop but nothing comes out + shows pain → Emergency! Could be a blockage',
            'If your pet may have swallowed something (string, fabric, bones) → Get to a vet right away!'
          ],
        ),
      ],
      'General': [
        const PetSymptom(
          name: 'Vomiting',
          description: 'Is your pet throwing up? Occasional vomiting can happen, but frequent or severe vomiting is a concern.',
          causes: [
            'Eating something they shouldn\'t have (like garbage or toxic plants)',
            'Infections (like parvovirus in dogs or panleukopenia in cats)',
            'Toxins (like chocolate or certain chemicals)',
            'Organ issues (like liver or kidney problems)'
          ],
          actions: [
            'If occasional & your pet is otherwise fine → Monitor for a day or two',
            'If persistent, severe, or if there are other symptoms (like diarrhea, lethargy, or bloating) → Vet visit ASAP'
          ],
        ),
        const PetSymptom(
          name: 'Diarrhea',
          description: 'Is your pet\'s poop runny or more frequent? Diarrhea can be caused by many things, some of which can be serious.',
          causes: [
            'Dietary indiscretion (eating garbage, table scraps, or new food too quickly)',
            'Infections (bacterial, viral, or parasitic)',
            'Toxins (like certain plants or chemicals)',
            'Organ issues (like liver or kidney problems)'
          ],
          actions: [
            'If mild & your pet is otherwise fine → Monitor for a day or two',
            'If persistent, severe, or if there are other symptoms (like vomiting, lethargy, or bloating) → Vet visit ASAP'
          ],
        ),
        const PetSymptom(
          name: 'Abdominal Pain or Discomfort',
          description: 'Is your pet acting like their belly hurts? They might be hiding, not eating, or crying out.',
          causes: [
            'Gastrointestinal issues (like pancreatitis or inflammatory bowel disease)',
            'Organ issues (like liver or kidney problems)',
            'Infections or toxins'
          ],
          actions: [
            'If mild & your pet is otherwise fine → Monitor',
            'If persistent, severe, or if your pet is showing signs of pain (like whining, panting, or restlessness) → Vet visit ASAP'
          ],
        ),
        const PetSymptom(
          name: 'Bloating',
          description: 'Is your pet\'s belly swollen or distended? Bloating can be a sign of a serious condition, especially if it comes on suddenly.',
          causes: [
            'Gas buildup (from eating too fast, dietary changes, or certain medical conditions)',
            'Fluid accumulation (from infections, tumors, or organ issues)',
            'Food or gastric torsion (a serious condition where the stomach twists)'
          ],
          actions: [
            'This can be serious → Vet visit ASAP',
            'Try to keep your pet calm and avoid feeding them until they are seen by a vet'
          ],
        ),
      ]
    },
    'legs': {
      // Legs symptoms remain the same
      'Movement & Limbs Issues': [
        const PetSymptom(
          name: 'Limping or Favoring One Leg',
          description: 'If your pet avoids putting weight on one leg, they might be in pain!',
          causes: [
            'Injury – A sprain, strain, or even a small cut on the paw',
            'Broken Bone or Dislocation – If the leg looks swollen or bent oddly',
            'Joint Pain (Arthritis) – Common in older pets, especially after rest',
            'Nerve Problem – If the leg drags or doesn\'t move properly',
            'Fall Injury – Can affect the spine, hips, or nerves'
          ],
          actions: [
            'Check the paw for cuts, swelling, or stuck objects',
            'If mild & improves in 24 hours → Monitor & rest',
            'If swollen, painful, or lasts more than a day → Vet check needed'
          ],
        ),
        const PetSymptom(
          name: 'Stiffness or Trouble Standing Up',
          description: 'If your pet struggles to get up or moves stiffly, their joints or muscles might be sore.',
          causes: [
            'Arthritis – Joint pain, especially in older pets',
            'Muscle Soreness – After heavy play or running',
            'Hip or Spine Problems – Especially in large dog breeds',
            'Nerve Issue – If the back legs seem weak or unsteady',
            'Fall Injury – Can affect the spine, hips, or nerves'
          ],
          actions: [
            'Give them a soft, warm place to rest',
            'If happens often or gets worse → Vet check needed'
          ],
        ),
        const PetSymptom(
          name: 'Sudden Weakness or Collapsing',
          description: 'If your pet suddenly can\'t stand or falls over, it\'s an emergency!',
          causes: [
            'Heart Problem – Can cause fainting episodes',
            'Severe Pain or Injury – A hidden issue making them weak',
            'Low Blood Sugar (Hypoglycemia) – More common in small breeds',
            'Nerve or Brain Issue – Can affect balance and movement'
          ],
          actions: [
            '🚨 Take your pet to the vet immediately!'
          ],
        ),
        const PetSymptom(
          name: 'Trembling or Shaking',
          description: 'Shaking can mean pain, cold, or something more serious!',
          causes: [
            'Pain or Stress – If shaking happens with whining or hiding',
            'Cold (Hypothermia) – Especially in small or short-haired pets',
            'Poisoning – If sudden shaking with vomiting or drooling',
            'Nerve Issue – If one leg or side shakes uncontrollably'
          ],
          actions: [
            'Keep them warm & calm',
            'If with vomiting, weakness, or confusion → Vet visit ASAP'
          ],
        ),
        const PetSymptom(
          name: 'Swollen or Painful Joints',
          description: 'If your pet\'s leg or joint looks swollen, something\'s not right!',
          causes: [
            'Injury or Sprain – From jumping or rough play',
            'Infection – If swelling comes with heat & redness',
            'Arthritis – Common in older pets, worsens over time',
            'Tick Disease – Some infections cause swollen joints',
            'Fall Injury – Can bruise or damage joints, causing swelling and pain'
          ],
          actions: [
            'If mild swelling & no pain → Rest & monitor',
            'If painful, hot, or getting worse → Vet check needed'
          ],
        ),
      ],
    },
    'tail': {
      // Tail symptoms remain the same
      'General': [
        const PetSymptom(
          name: 'Tail Chasing or Excessive Grooming',
          description: 'Is your pet chasing their tail or grooming themselves excessively? They might be bored, anxious, or have a medical issue.',
          causes: [
            'Boredom or lack of exercise',
            'Anxiety or stress',
            'Allergies or irritants (like fleas or certain foods)',
            'Infections or parasites (like mites or ringworm)'
          ],
          actions: [
            'If occasional → Monitor & provide more exercise or mental stimulation',
            'If persistent, severe, or if there are other symptoms (like redness, swelling, or hair loss) → Vet visit recommended'
          ],
        ),
        const PetSymptom(
          name: 'Tail Paralysis or Weakness',
          description: 'Is your pet\'s tail drooping or unable to move it? This can be a sign of a serious condition.',
          causes: [
            'Nerve injury or damage',
            'Spinal cord issues',
            'Severe infection or inflammation'
          ],
          actions: [
            'This could be serious → Vet visit ASAP',
            'Keep your pet calm and avoid pulling or putting pressure on the tail'
          ],
        ),
        const PetSymptom(
          name: 'Lumps or Bumps on the Tail',
          description: 'Not all lumps are bad, but it\'s always best to check!',
          causes: [
            'Benign Fatty Lump (Lipoma) – Soft, slow-growing, harmless',
            'Abscess – A pus-filled lump from an infection or bite',
            'Tumor – Can be harmless or serious (vet check needed)',
            'Allergic Reaction – Swollen skin from a bug bite or sting'
          ],
          actions: [
            'If small, soft, & not growing fast → Monitor but mention it to your vet',
            'If hard, growing, or painful → Vet visit ASAP'
          ],
        ),
      ]
    },
    'skin': {
      // Skin symptoms remain the same
      'Skin & Coat Symptoms': [
        const PetSymptom(
          name: 'Hair Loss (Bald Spots)',
          description: 'If your pet is losing more hair than usual, it\'s time to check what\'s going on!',
          causes: [
            'Normal Shedding – Some breeds shed a lot seasonally, but no bald spots should appear',
            'Allergies – Food, fleas, or something in the environment',
            'Fleas or Mites – Tiny bugs that make pets itch and lose fur',
            'Ringworm – A fungal infection that causes round bald patches',
            'Stress or Overgrooming – Some pets lick or scratch too much when stressed'
          ],
          actions: [
            'If mild hair loss & no redness → Monitor for changes & keep a healthy diet',
            'If you see fleas or ticks → Ask your vet about flea prevention & check vaccine dates',
            'If too much hair is falling out → Vet check needed',
            'If patches are growing, red, or scabby → Vet visit ASAP!'
          ],
        ),
        const PetSymptom(
          name: 'Itchy Skin (Scratching a Lot)',
          description: 'A little scratching is normal, but too much means something\'s wrong!',
          causes: [
            'Fleas or Mites – Tiny parasites that cause intense itching',
            'Skin Infection – Bacteria or fungus can irritate the skin',
            'Allergies – Food, pollen, dust, or even shampoo!'
          ],
          actions: [
            'Check for fleas (look near the tail & belly)',
            'If mild scratching → Brush daily & monitor for changes',
            'If excessive scratching → Vet check & make sure flea prevention is up to date',
            'If red skin, hair loss, or sores → Vet check needed'
          ],
        ),
        const PetSymptom(
          name: 'Red or Inflamed Skin',
          description: 'If your pet\'s skin looks red or sore, it\'s usually due to allergies, irritation, or an infection.',
          causes: [
            'Allergic reaction – Food, fleas, or something they touched',
            'Hot Spots – Raw, wet, irritated patches from too much licking',
            'Skin Infection – Bacteria or fungus causing swelling & redness',
            'Sunburn – Yes, pets can get sunburned, especially light-colored ones!'
          ],
          actions: [
            'If mild redness → Keep the area clean & monitor',
            'If spreading, oozing, or painful → Vet needed for treatment'
          ],
        ),
        const PetSymptom(
          name: 'Dandruff (Flaky Skin)',
          description: 'If your pet\'s fur has little white flakes, it might be dry skin or something more!',
          causes: [
            'Dry air – Common in winter or low humidity',
            'Poor diet – Lack of good fats can dry out the skin',
            'Parasites – Mites or fleas can cause flakiness',
            'Skin infection – If flakes come with redness or itching'
          ],
          actions: [
            'Brush daily to remove flakes',
            'If flakes come with itching or hair loss → Vet check needed'
          ],
        ),
        const PetSymptom(
          name: 'Oily or Greasy Fur',
          description: 'If your pet\'s fur feels greasy or smells bad, their skin might be out of balance!',
          causes: [
            'Seborrhea – A skin condition causing greasy or flaky fur',
            'Poor grooming – Some pets struggle to clean themselves',
            'Skin infection – Bacteria or fungus making skin oily'
          ],
          actions: [
            'Brush daily to distribute natural oils',
            'If bad smell, redness, or hair loss → Vet visit needed'
          ],
        ),
        const PetSymptom(
          name: 'Scabs or Crusty Skin',
          description: 'If you notice small scabs, check if your pet has been scratching a lot!',
          causes: [
            'Scratching or biting too much (due to fleas, allergies, or infections)',
            'Skin infection – Bacteria causing sores and crusty patches',
            'Mites (Mange) – Tiny bugs that burrow under the skin'
          ],
          actions: [
            'Check for fleas or mites (look under fur, near belly & armpits)',
            'If fleas are found → Vet check & flea prevention needed',
            'If scabs spread or look infected → Vet check needed'
          ],
        ),
        const PetSymptom(
          name: 'Lumps or Bumps',
          description: 'Not all lumps are bad, but it\'s always best to check!',
          causes: [
            'Benign Fatty Lump (Lipoma) – Soft, slow-growing, harmless',
            'Abscess – A pus-filled lump from an infection or bite',
            'Tumor – Can be harmless or serious (vet check needed)',
            'Allergic Reaction – Swollen skin from a bug bite or sting'
          ],
          actions: [
            'If small, soft, & not growing fast → Monitor but mention it to your vet',
            'If hard, growing, or painful → Vet visit ASAP'
          ],
        ),
        const PetSymptom(
          name: 'Skin Turning Darker (Hyperpigmentation)',
          description: 'If your pet\'s skin is getting darker, it could mean irritation or long-term skin issues.',
          causes: [
            'Chronic irritation – From allergies, licking, or rubbing',
            'Hormonal issues – Like hypothyroidism in dogs',
            'Aging – Some pets naturally get darker skin with age'
          ],
          actions: [
            'If no other symptoms → Monitor, may be normal',
            'If hair loss, itching, or weight changes → Vet check needed'
          ],
        ),
      ],
    },
    
    // New category: Pelvis - combines male_genitals, female_genitals, and urinary
    'pelvis': {
      'Male Genital Problems': [
        const PetSymptom(
          name: 'Swollen Testicles',
          description: 'If your pet\'s testicles look bigger than usual, something\'s up!',
          causes: [
            'Infection or inflammation',
            'Trauma (like a hit or fall)',
            'Testicular tumors (especially in older, unneutered dogs)',
            'Torsion (twisted testicle—very painful!)'
          ],
          actions: [
            'If mild swelling & no pain → Monitor, but get it checked soon',
            'If swelling + redness or pain → Vet visit needed',
            'If one testicle looks much bigger than the other → Might be serious, vet ASAP!'
          ],
        ),
        const PetSymptom(
          name: 'Discharge from the Penis',
          description: 'A little yellowish or clear fluid is normal, but heavy discharge isn\'t!',
          causes: [
            'Normal smegma (small yellowish fluid – nothing to worry about)',
            'Infection (if it\'s thick, smelly, or greenish)',
            'Injury or irritation',
            'Prostate problems in older, unneutered dogs'
          ],
          actions: [
            'If just a little clear/yellow fluid → Normal, wipe it off',
            'If thick, smelly, or green → Vet visit needed',
            'If your pet keeps licking it a lot → Could be an infection, check with a vet'
          ],
        ),
        const PetSymptom(
          name: 'Red, Swollen, or Hanging Out Penis',
          description: 'If your pet\'s penis won\'t go back inside, it\'s an emergency!',
          causes: [
            'Hair or dirt stuck, preventing retraction',
            'Nerve damage or trauma',
            'Infection or inflammation'
          ],
          actions: [
            'If mild swelling, but retracts → Vet visit soon',
            'If penis stays out, red, or swollen → Emergency! Wrap in a damp cloth & go to vet immediately!'
          ],
        ),
        const PetSymptom(
          name: 'One or Both Testicles Missing',
          description: 'If your pet never had both testicles drop, it\'s not just cosmetic—it can be dangerous!',
          causes: [
            'Genetic condition (common in some breeds)',
            'Retained testicle (stuck inside the body, can turn cancerous)'
          ],
          actions: [
            'If puppy or kitten under 6 months → Monitor, might drop naturally',
            'If older than 6 months & still missing → Vet visit needed, may need surgery'
          ],
        ),
        const PetSymptom(
          name: 'Testicles Suddenly Shrinking or Getting Hard',
          description: 'If your pet\'s testicles look smaller or feel hard, it could be serious!',
          causes: [
            'Hormonal issues',
            'Testicular degeneration (common in older dogs)',
            'Testicular cancer'
          ],
          actions: [
            'If gradual shrinkage, no other symptoms → Vet checkup recommended',
            'If sudden shrinkage or one testicle hard → Vet ASAP!'
          ],
        ),
        const PetSymptom(
          name: 'Lumps or Bleeding from the Genitals',
          description: 'If you notice a lump, sore, or bleeding around your pet\'s genitals, don\'t ignore it!',
          causes: [
            'Infection – Swelling, pus, or redness could mean a bacterial or fungal infection',
            'Injury or Irritation – From rough surfaces, excessive licking, or trauma',
            'Tumor or Growth – Some lumps are harmless, but others (like TVT) need treatment',
            'TVT (Transmissible Venereal Tumor) – A contagious cancer spread between dogs, common in strays and unneutered pets'
          ],
          actions: [
            'Check for swelling, redness, or pus (clean gently with warm water)',
            'If mild irritation: Prevent licking and monitor for a day',
            'If the lump is red, growing, or bleeding → Vet visit ASAP!',
            'If your pet had contact with stray dogs → Get them checked, could be TVT'
          ],
        ),
      ],
      'Female Genital Problems': [
        const PetSymptom(
          name: 'Swollen Vulva',
          description: 'If your pet\'s vulva looks swollen, it might be a natural part of her cycle—or a health issue!',
          causes: [
            'Normal Heat Cycle – Female dogs naturally have swelling and behavior changes when in heat',
            'Infection (vaginitis) – If swelling comes with discharge or excessive licking',
            'Allergic reaction – From food, grass, or cleaning products',
            'Trauma or irritation – From excessive licking or rough surfaces'
          ],
          actions: [
            'Check for heat signs → If swelling comes with behavioral changes (restlessness, attracting male dogs, or spotting blood), it\'s likely normal heat',
            'If unsure → Monitor for 2–3 days; if swelling worsens or there\'s discharge, see a vet',
            'If swelling is sudden, severe, or painful → Vet visit needed'
          ],
        ),
        const PetSymptom(
          name: 'Discharge from the Vulva',
          description: 'A little clear or whitish discharge is normal, but anything smelly or unusual isn\'t!',
          causes: [
            'Normal Heat Cycle – If your pet isn\'t spayed, a small amount of clear discharge is expected',
            'Infection (Vaginitis or UTI) – Bacteria can cause irritation and unusual discharge',
            'Pyometra (Serious Uterus Infection!) – Happens in unspayed females and can be deadly if untreated',
            'Tumors or Growths – Less common, but possible in older pets'
          ],
          actions: [
            'If clear discharge with no smell & pet seems fine → Likely normal, especially if in heat',
            'If thick, yellow, green, or smelly discharge → Vet visit ASAP! Could be an infection or pyometra',
            'If your pet is weak, drinking lots of water, or has a swollen belly → Emergency! Pyometra is deadly'
          ],
        ),
        const PetSymptom(
          name: 'Excessive Licking of Genital Area',
          description: 'A little licking is normal, but constant licking means something\'s wrong!',
          causes: [
            'Infection (UTI or Vaginitis) – Bacteria can cause irritation and discomfort',
            'Irritation from Allergies or Insect Bites – Can make the area itchy',
            'Pyometra (Serious Infection in Unspayed Females!) – A dangerous condition that needs urgent care',
            'Something Stuck in the Area – Like dirt, hair, or a small object'
          ],
          actions: [
            'If occasional licking & no other symptoms → Likely normal, just monitor',
            'If constant licking + redness or swelling → Vet visit needed',
            'If licking + discharge or bad smell → Possible infection or pyometra, see a vet ASAP!'
          ],
        ),
        const PetSymptom(
          name: 'Bleeding or Lumps Around the Vulva',
          description: 'If you see red, bleeding sores or strange lumps near your pet\'s private area, it could be a serious problem!',
          causes: [
            'Infection – Swelling, pus, or redness could mean a bacterial or fungal infection',
            'Injury or Irritation – From rough surfaces, excessive licking, or trauma',
            'Tumor or Growth – Some lumps are harmless, but others (like TVT) need treatment',
            'TVT (Transmissible Venereal Tumor) – A contagious cancer spread between dogs, common in strays and unneutered pets'
          ],
          actions: [
            'Check for swelling, redness, or pus (clean gently with warm water)',
            'If mild irritation: Prevent licking and monitor for a day',
            'If the lump is red, growing, or bleeding → Vet visit ASAP!',
            'If your pet had contact with stray dogs → Get them checked, could be TVT'
          ],
        ),
        const PetSymptom(
          name: 'Something Sticking Out from the Vulva',
          description: 'If you see a pink or red lump coming out of your pet\'s vulva, it\'s serious!',
          causes: [
            'Straining During Birth or Heat – Can push tissue out',
            'Weak Pelvic Muscles – More common in older pets',
            'Injury or Hormonal Issues – Can lead to tissue slipping out'
          ],
          actions: [
            'Do NOT try to push it back in!',
            'Keep the area clean and moist (use a damp cloth)',
            'Emergency vet visit needed! Surgery may be required'
          ],
        ),
        const PetSymptom(
          name: 'Bleeding from the Genital Area',
          description: 'Noticing blood? It could be normal or something serious!',
          causes: [
            'Normal Heat Cycle (Unspayed Females) – Light bleeding can happen during heat',
            'Pyometra (Dangerous Uterus Infection) – Often in unspayed females, needs urgent care',
            'Injury or Trauma – Scratches, bites, or rough play can cause bleeding',
            'Tumors or Polyps – Growths in the reproductive tract may bleed',
            'Blood Clotting Problems – Rare, but can cause unexplained bleeding'
          ],
          actions: [
            'If small spots of blood & your pet isn\'t spayed → Could be heat, monitor for other signs',
            'If bleeding is heavy or your pet is weak, has a fever, or a swollen belly → Emergency! Vet ASAP!'
          ],
        ),
      ],
      'Urination Problems': [
        const PetSymptom(
          name: 'Peeing Too Much (Frequent Urination)',
          description: 'If your pet is peeing way more than usual, even in small amounts, something might be wrong!',
          causes: [
            'Bladder Infection (UTI) – Can cause frequent, painful peeing',
            'Diabetes or Kidney Issues – Often comes with drinking more water',
            'Hormonal Problems (Cushing\'s Disease) – Affects urine control',
            'Anxiety or Excitement – Can cause nervous peeing'
          ],
          actions: [
            'If drinking a lot more water than usual → Book a vet visit to rule out diabetes or kidney issues',
            'If peeing often + straining or having accidents → Could be a UTI, needs vet care',
            'If no other symptoms and pet acts normal → Monitor for 24 hours; if it continues, see a vet'
          ],
        ),
        const PetSymptom(
          name: 'Straining to Pee (Difficulty Urinating)',
          description: 'If your pet squats for a long time but only a few drops come out, something might be wrong!',
          causes: [
            'Bladder Infection (UTI) – Can make peeing painful and difficult',
            'Bladder Stones – Can block urine flow or cause irritation',
            'Urinary Blockage (Dangerous in Male Cats!) – A life-threatening emergency',
            'Prostate Issues (Male Dogs) – Can cause difficulty urinating'
          ],
          actions: [
            'If straining + only small drops come out → Vet visit needed (could be infection or stones)',
            'If trying to pee but nothing comes out → Emergency! Urinary blockage can be fatal',
            'If straining + blood in urine → See a vet; may be an infection or bladder stones'
          ],
        ),
        const PetSymptom(
          name: 'Peeing in the Wrong Places',
          description: 'If your pet suddenly starts peeing where they shouldn\'t, there\'s usually a reason!',
          causes: [
            'Territory Marking or Mating Behavior – Often happens in pets that haven\'t been spayed or neutered',
            'Bladder Infection (UTI) – Can cause urgent, frequent urination',
            'Stress or Anxiety – Changes in the home can trigger accidents',
            'Bladder Control Issues – More common in older pets',
            'Diabetes or Kidney Disease – Can cause excessive urination'
          ],
          actions: [
            'If peeing on furniture or walls → Could be marking behavior. Spaying/neutering may help',
            'If fully house-trained but suddenly peeing in the wrong places → Look for signs of a UTI: frequent peeing, straining, or blood in urine. If you notice these, see a vet',
            'If accidents only happen when scared or excited → Could be stress or submissive peeing. Try keeping a calm environment',
            'If it happens in an older pet → Bladder control issues may need medication, check with a vet'
          ],
        ),
        const PetSymptom(
          name: 'Bloody Urine',
          description: 'If your pet\'s pee looks red or pink, don\'t ignore it!',
          causes: [
            'Urinary tract infection (UTI) – Can cause irritation and bleeding',
            'Bladder Stones or Crystals – May scratch the bladder, leading to blood in urine',
            'Tumors in the Bladder or Urinary Tract – More common in older pets',
            'Injury or Trauma – A fall or accident could cause internal bleeding'
          ],
          actions: [
            'If bloody urine + frequent peeing or straining → Vet visit ASAP! Could be an infection or stones',
            'If blood appears once but your pet acts normal → Monitor closely, but a vet check is still safest',
            'If your pet was recently injured or fell from a height → Vet check needed to rule out internal damage'
          ],
        ),
        const PetSymptom(
          name: 'Leaking Urine',
          description: 'If your pet is leaving wet spots where they sit, it might be an issue with bladder control',
          causes: [
            'Weak Bladder Muscles – Common in older or spayed female dogs',
            'Urinary Tract Infection (UTI) – Can cause irritation and leaking',
            'Nerve Damage – May affect bladder control, especially after injury',
            'Prostate Problems (in Males) – Can lead to urine dribbling'
          ],
          actions: [
            'If small leaks happen while resting → Monitor and keep the area clean. If it continues, see a vet',
            'If leaking + licking the area → Could be an infection, needs vet care',
            'If leaking + trouble walking → May be nerve-related, see a vet',
            'If urine smells strong or looks cloudy → Possible UTI, vet visit needed'
          ],
        ),
        const PetSymptom(
          name: 'Not Peeing At All',
          description: 'If your pet hasn\'t peed in over 24 hours, it\'s a life-threatening emergency!',
          causes: [
            'Urinary blockage – Common in male cats and can be fatal if untreated',
            'Kidney failure – The kidneys stop filtering waste, leading to toxin buildup',
            'Severe dehydration – Can happen after vomiting, diarrhea, or heat exposure'
          ],
          actions: [
            'If your pet tries to pee but nothing comes out → EMERGENCY! Get to a vet immediately',
            'If no peeing + weak or tired → Could be kidney failure, seek urgent care',
            'If no pee + recent illness or dehydration → Needs fluids and immediate vet attention'
          ],
        ),
      ],
    },
    
    // New category: Buttocks - contains anus-related symptoms
    'buttocks': {
      'Anus & Pooping Issues': [
        const PetSymptom(
          name: 'Scooting or Dragging Butt on the Floor',
          description: 'If your pet keeps sliding their butt on the floor, they might be itchy or uncomfortable!',
          causes: [
            'Full or Infected Anal Glands – Small sacs near the anus get blocked (common in dogs)',
            'Worms – Especially tapeworms, which cause itching',
            'Allergies or Skin Irritation – From food, grass, or cleaning products',
            'Poop Stuck to Fur – Especially in long-haired pets'
          ],
          actions: [
            'Clean the area gently with warm water',
            'Check for worms (look for small rice-like pieces near the butt)',
            'Make sure your pet is up to date on deworming',
            'If scooting continues or there\'s swelling → Vet check needed'
          ],
        ),
        const PetSymptom(
          name: 'Swelling or Redness Around the Anus',
          description: 'A swollen or red butt usually means pain, infection, or irritation!',
          causes: [
            'Anal Gland Infection – Painful swelling, sometimes with pus',
            'Allergic Reaction – To food, cleaning products, or parasites',
            'Hemorrhoids (in dogs) – Swollen blood vessels from straining',
            'Rectal Prolapse – A serious case where part of the rectum comes out (needs urgent care!)'
          ],
          actions: [
            'If mild redness with no pain → Monitor & keep the area clean',
            'If swollen, painful, or has discharge → Vet visit needed ASAP'
          ],
        ),
        const PetSymptom(
          name: 'Blood in Stool or Around the Anus',
          description: 'Seeing blood? It could be minor or something serious!',
          causes: [
            'Small Tear from Straining – If poop was hard or dry',
            'Worms or Parasites – Hookworms and whipworms cause bleeding',
            'Anal Gland Infection – Can bleed if severe',
            'Serious Conditions – Like colitis, tumors, or poisoning'
          ],
          actions: [
            'If just a tiny streak & pet is normal → Monitor',
            'If lots of blood, diarrhea, or pet is weak → Emergency vet visit!'
          ],
        ),
        const PetSymptom(
          name: 'Straining to Poop or Constipation',
          description: 'If your pet keeps trying to poop but nothing comes out, they might be constipated!',
          causes: [
            'Not Drinking Enough Water – Leads to hard, dry poop',
            'Hairballs (in cats) – Can block the intestines',
            'Eating Bones or Foreign Objects – Can cause a blockage',
            'Anal Gland Problem – Painful glands can make pooping hard',
            'Serious Issues – If straining comes with vomiting or bloating'
          ],
          actions: [
            'Give more water & fiber (mashed boiled potatoes or carrots can help)',
            'If straining for more than a day or seems painful → Vet visit needed'
          ],
        ),
        const PetSymptom(
          name: 'Diarrhea',
          description: 'Loose, watery poop? It might be something simple or more serious!',
          causes: [
            'Diet Change or Eating Something Bad – Common cause of mild diarrhea',
            'Worms or Infections – Especially in younger pets',
            'Stress or Anxiety – Can cause tummy issues',
            'Serious Illness – If diarrhea is bloody or long-lasting'
          ],
          actions: [
            'Give bland food (boiled chicken & rice)',
            'Keep your pet hydrated —dehydration is a major risk and can be life-threatening!',
            'If diarrhea lasts more than two days, has blood, or pet is weak → Vet check needed'
          ],
        ),
      ],
    },
  };
  
  /// Convert the class-based model to map representation for ease of use
  static Map<String, Map<String, List<Map<String, dynamic>>>> getSymptomMaps() {
    final result = <String, Map<String, List<Map<String, dynamic>>>>{};
    
    symptoms.forEach((bodyPart, categories) {
      result[bodyPart] = {};
      categories.forEach((category, symptomList) {
        result[bodyPart]![category] = symptomList.map((symptom) => symptom.toMap()).toList();
      });
    });
    
    return result;
  }
}