import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';

/// Data model for a symptom with photo support
class PetSymptom {
  final String name;
  final String description;
  final List<String> causes;
  final List<String> actions;
  final String? imagePath;
  final String? emergencyLevel;

  const PetSymptom({
    required this.name,
    required this.description,
    required this.causes,
    required this.actions,
    this.imagePath,
    this.emergencyLevel,
  });

  /// Get localized name with fallback
  String getLocalizedName(BuildContext context) {
    AppLocalizations? localizations;
    try {
      localizations = AppLocalizations.of(context);
    } catch (e) {
      localizations = null;
    }
    return localizations?.getSymptomName(name) ?? name;
  }

  /// Get localized description with fallback
  String getLocalizedDescription(BuildContext context) {
    AppLocalizations? localizations;
    try {
      localizations = AppLocalizations.of(context);
    } catch (e) {
      localizations = null;
    }
    return localizations?.getSymptomDescription(name) ?? description;
  }

  /// Get localized causes with fallback
  List<String> getLocalizedCauses(BuildContext context) {
    AppLocalizations? localizations;
    try {
      localizations = AppLocalizations.of(context);
    } catch (e) {
      localizations = null;
    }

    if (localizations == null) return causes;

    return causes.asMap().entries.map((entry) {
      final index = entry.key;
      final originalCause = entry.value;
      return localizations?.getSymptomCause(name, index) ?? originalCause;
    }).toList();
  }

  /// Get localized actions with fallback
  List<String> getLocalizedActions(BuildContext context) {
    AppLocalizations? localizations;
    try {
      localizations = AppLocalizations.of(context);
    } catch (e) {
      localizations = null;
    }

    if (localizations == null) return actions;

    return actions.asMap().entries.map((entry) {
      final index = entry.key;
      final originalAction = entry.value;
      return localizations?.getSymptomAction(name, index) ?? originalAction;
    }).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'causes': causes,
      'actions': actions,
      'imagePath': imagePath,
      'emergencyLevel': emergencyLevel,
    };
  }
}

/// Comprehensive pet symptom data based on Aleefy veterinary guide
class PetSymptomData {
  /// Get localized category name with fallback
  static String getLocalizedCategoryName(
      BuildContext context, String category) {
    AppLocalizations? localizations;
    try {
      localizations = AppLocalizations.of(context);
    } catch (e) {
      localizations = null;
    }

    switch (category) {
      case 'Eye Symptoms':
        return localizations?.eyeSymptoms ?? 'Eye Symptoms';
      case 'Ear Symptoms':
        return localizations?.earSymptoms ?? 'Ear Symptoms';
      case 'Mouth & Teeth Symptoms':
        return localizations?.mouthTeethSymptoms ?? 'Mouth & Teeth Symptoms';
      case 'Skin & Coat Symptoms':
        return localizations?.skinCoatSymptoms ?? 'Skin & Coat Symptoms';
      case 'Movement & Limbs Issues':
        return localizations?.movementLimbsIssues ?? 'Movement & Limbs Issues';
      case 'Anus & Pooping Issues':
        return localizations?.anusPoopingIssues ?? 'Anus & Pooping Issues';
      case 'Male Genital Problems':
        return localizations?.maleGenitalProblems ?? 'Male Genital Problems';
      case 'Female Genital Problems':
        return localizations?.femaleGenitalProblems ??
            'Female Genital Problems';
      case 'Urination Problems':
        return localizations?.urinationProblems ?? 'Urination Problems';
      default:
        return category;
    }
  }

  /// Get emergency level color
  static Color getEmergencyColor(String? emergencyLevel) {
    switch (emergencyLevel?.toLowerCase()) {
      case 'emergency':
        return Colors.red;
      case 'urgent':
        return Colors.orange;
      case 'moderate':
        return Colors.yellow;
      case 'mild':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  /// Search symptoms by query with localization support
  static List<PetSymptom> searchSymptoms(String query,
      [BuildContext? context]) {
    if (query.isEmpty) return [];

    final allSymptoms = getAllSymptoms();
    final lowerQuery = query.toLowerCase();

    return allSymptoms.where((symptom) {
      if (context != null) {
        // Search in localized content if context is available
        return symptom
                .getLocalizedName(context)
                .toLowerCase()
                .contains(lowerQuery) ||
            symptom
                .getLocalizedDescription(context)
                .toLowerCase()
                .contains(lowerQuery) ||
            symptom
                .getLocalizedCauses(context)
                .any((cause) => cause.toLowerCase().contains(lowerQuery)) ||
            symptom
                .getLocalizedActions(context)
                .any((action) => action.toLowerCase().contains(lowerQuery));
      } else {
        // Fallback to original content
        return symptom.name.toLowerCase().contains(lowerQuery) ||
            symptom.description.toLowerCase().contains(lowerQuery) ||
            symptom.causes
                .any((cause) => cause.toLowerCase().contains(lowerQuery)) ||
            symptom.actions
                .any((action) => action.toLowerCase().contains(lowerQuery));
      }
    }).toList();
  }

  /// All symptom data organized by body part and category
  static final Map<String, Map<String, List<PetSymptom>>> symptoms = {
    'head': {
      'Eye Symptoms': [
        const PetSymptom(
          name: 'Eye Redness',
          description:
              'Noticed your pet\'s eye looking red? It could be something small like dust or something serious like an infection.',
          causes: [
            'Dust, wind, or allergies',
            'Infection (like bacteria or herpes virus)',
            'High eye pressure (glaucoma)',
            'Injury or irritation'
          ],
          actions: [
            'If mild → Rinse with saline & monitor',
            'If the eye is swollen, squinting, has discharge, or your pet is pawing at it → Vet visit ASAP'
          ],
          imagePath: 'assets/images/symptoms/eye_redness.png',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Eye Discharge (Goopy Stuff)',
          description:
              'A little eye goop can be normal, but if it\'s thick, yellow, or green, it might mean an infection.',
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
          imagePath: 'assets/images/symptoms/eye_discharge.jpg',
          emergencyLevel: 'mild',
        ),
        const PetSymptom(
          name: 'Cloudy Eye (Looks Foggy or Bluish)',
          description:
              'If your pet\'s eye looks cloudy or milky, it could be a normal age change or something serious.',
          causes: [
            'Older pets: Normal aging',
            'Cataracts (can cause blindness)',
            'Corneal ulcers (after injury or infection)',
            'High eye pressure (glaucoma)'
          ],
          actions: [
            'If gradual change in an older pet → Mention at next vet check-up',
            'If sudden cloudiness, pain, or squinting → Vet visit ASAP, delaying can cause blindness'
          ],
          imagePath: 'assets/images/symptoms/cloudy_eye.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Watery Eyes (Excessive Tearing)',
          description:
              'Some tearing is normal, but too much can mean an issue.',
          causes: [
            'Allergies or mild irritation',
            'Blocked tear ducts (common in small dogs)',
            'Infection (like feline calicivirus)',
            'Infection or corneal ulcers (if redness & squinting)'
          ],
          actions: [
            'If mild & no other signs → Wipe & monitor',
            'If excessive, with redness or rubbing → Vet check is needed'
          ],
          imagePath: 'assets/images/symptoms/watery_eyes.jpg',
          emergencyLevel: 'mild',
        ),
        const PetSymptom(
          name: 'Third Eyelid Showing',
          description:
              'Is there a white or pink piece of tissue covering part of your pet\'s eye, or sticking out from the corner? That\'s the third eyelid.',
          causes: [
            'Normal after sleeping – The third eyelid may show briefly when your pet wakes up',
            'Eye infection or nerve issues – Can cause the eyelid to stay up or become more visible',
            'In dogs: A pink lump in the inner corner might mean the gland inside the third eyelid has popped out',
            'In cats: A white membrane covering both eyes could be a sign of illness'
          ],
          actions: [
            'If it goes away quickly and your pet is acting normal → No need to worry, just monitor',
            'If the third eyelid stays up or covers part of the eye → Book a vet visit to check the cause',
            'If you see swelling, redness, or your pet can\'t open the eye fully → See a vet as soon as possible',
            'Don\'t try to touch or push the tissue back — this can cause more harm'
          ],
          imagePath: 'assets/images/symptoms/third_eyelid.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Squinting or Keeping Eye Closed',
          description:
              'If your pet keeps one eye closed or blinks a lot, they might be in pain.',
          causes: [
            'Irritation from dust or hair',
            'Corneal ulcer (scratch on the eye)',
            'Infection or high eye pressure'
          ],
          actions: [
            'If mild & improves quickly → Monitor & rinse with saline',
            'If ongoing squinting or rubbing → Vet visit ASAP'
          ],
          imagePath: 'assets/images/symptoms/squinting_eye.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Swelling Around the Eye',
          description:
              'If your pet\'s eye looks puffy or swollen, something is irritating it.',
          causes: [
            'Allergy or mild irritation',
            'Infection or injury',
            'Abscess or tumor (rare but possible)'
          ],
          actions: [
            'If mild swelling & no other symptoms → Cold compress & monitor',
            'If severe swelling, pain, or redness → Vet visit ASAP'
          ],
          imagePath: 'assets/images/symptoms/eye_swelling.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Worms in the Eye',
          description:
              'Seeing something moving in your pet\'s eye? It might be a worm — and it needs quick attention.',
          causes: [
            'Worms or white threads in or around the eye may be caused by a type of parasite',
            'These can damage the eye and cause pain, redness, or even vision loss if not treated quickly'
          ],
          actions: [
            'Do not touch or try to remove the worm — this can harm the eye',
            'Keep your pet calm and try to prevent them from scratching the eye',
            'Take your pet to the vet immediately — they need proper treatment and medication'
          ],
          imagePath: 'assets/images/symptoms/eye_worms.jpg',
          emergencyLevel: 'emergency',
        ),
      ],
      'Ear Symptoms': [
        const PetSymptom(
          name: 'Itchy Ears (Scratching or Head Shaking)',
          description:
              'If your pet is shaking their head like a mini rockstar or scratching their ears a lot, something is bugging them!',
          causes: [
            'Ear infection (bacteria or yeast)',
            'Ear mites (tiny bugs, common in cats)',
            'Allergies (food or environmental)',
            'Something stuck inside (grass, dirt)'
          ],
          actions: [
            'If mild & ears look normal → Wipe gently & monitor',
            'If redness, swelling, or bad smell → Vet visit needed',
            'If shaking a lot → Act fast! Too much shaking can cause an ear hematoma (a painful blood pocket)'
          ],
          imagePath: 'assets/images/symptoms/itchy_ears.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Black Stuff in the Ear (Dark Wax or Debris)',
          description:
              'Noticed dark gunk in your pet\'s ears? It could be harmless wax or a sign of mites or infection!',
          causes: [
            'Normal wax (small amounts, no smell)',
            'Ear mites (coffee-ground-like debris, very itchy)',
            'Yeast or bacterial infection (smelly, moist)'
          ],
          actions: [
            'If small amounts & no scratching → Clean gently',
            'If itchy, smelly, or a lot of black debris → Vet check recommended'
          ],
          imagePath: 'assets/images/symptoms/ear_black_debris.jpg',
          emergencyLevel: 'mild',
        ),
        const PetSymptom(
          name: 'Red or Swollen Ear',
          description:
              'Is your pet\'s ear red, puffy, or warm to the touch? It could be an infection, allergy, or swelling from too much head shaking.',
          causes: [
            'Allergy – From food, fleas, or something in the environment',
            'Swelling from Shaking – A soft, balloon-like ear may be from broken blood vessels inside the ear flap',
            'Bug Bite or Injury – Can also cause sudden swelling or redness'
          ],
          actions: [
            'If the ear is just red and your pet acts normal → You can gently clean the outer ear and monitor',
            'If the ear is swollen, warm, painful, or smells bad → Vet check is needed for proper treatment',
            'If the ear looks puffy like a pillow or soft balloon → Your pet may need a small procedure to drain it — don\'t wait',
            'If your pet is constantly shaking their head or scratching → A vet visit is needed to stop the cause and prevent more damage'
          ],
          imagePath: 'assets/images/symptoms/swollen_ear.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Bad Smell from the Ear',
          description:
              'If your pet\'s ears smell like stinky cheese or moldy socks, it\'s usually an infection.',
          causes: [
            'Yeast or bacterial infection (common in floppy-eared dogs)',
            'Mites (if also itchy & dark debris)',
            'Foreign object (grass, dirt, or small bugs stuck inside)'
          ],
          actions: [
            'If mild smell & no redness → Clean gently and monitor',
            'If strong smell, discharge, or pain → Vet visit needed'
          ],
          imagePath: 'assets/images/symptoms/ear_smell.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Ear Discharge (Pus or Liquid Coming Out)',
          description:
              'If there\'s liquid or pus coming from the ear, it\'s usually an infection or something stuck inside.',
          causes: [
            'Ear infection (yellow, brown, or green discharge)',
            'Ear mites (dark coffee-ground debris)',
            'Foreign object (can cause irritation & infection)'
          ],
          actions: [
            'If mild & clear discharge → Wipe gently & monitor',
            'If thick, yellow/green, or smells bad → Vet visit ASAP'
          ],
          imagePath: 'assets/images/symptoms/ear_discharge.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Tilting Head to One Side',
          description:
              'Is your pet holding their head to one side, like they\'re trying to listen or think? It could be a sign of an ear problem or balance issue.',
          causes: [
            'Ear Infection – Especially in the inner or middle ear',
            'Ear Mites – If your pet is also scratching a lot',
            'Balance Problem (Vestibular Disease) – More common in older dogs'
          ],
          actions: [
            'If it just started and your pet seems normal otherwise → Monitor closely for the next 24 hours',
            'If the tilt continues or gets worse → Book a vet visit to check the ears',
            'If your pet is falling, walking in circles, or has trouble standing → Go to the vet immediately'
          ],
          imagePath: 'assets/images/symptoms/head_tilt.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Loss of Hearing or Not Responding to Sounds',
          description:
              'If your pet doesn\'t react to noises like they used to, their hearing might be affected.',
          causes: [
            'Ear infection or wax buildup (temporary hearing loss)',
            'Old age (gradual deafness)',
            'Ear injury or nerve damage',
            'Genetic causes (some pets, especially all-white ones, can be born deaf)'
          ],
          actions: [
            'If sudden hearing loss → Vet visit ASAP',
            'If gradual & pet is aging or loss is genetic → Monitor & adjust how you communicate (hand signals help!)'
          ],
          imagePath: 'assets/images/symptoms/hearing_loss.jpg',
          emergencyLevel: 'moderate',
        ),
      ],
      'Mouth & Teeth Symptoms': [
        const PetSymptom(
          name: 'Bad Breath (Smelly Mouth)',
          description:
              'If your pet\'s kisses smell like a garbage can, something\'s up!',
          causes: [
            'Dental disease (plaque, gingivitis, or infected teeth)',
            'Something stuck (food, hair, or a foreign object)',
            'Kidney or liver problems (if breath smells like urine)'
          ],
          actions: [
            'If mild smell → Try brushing with pet-safe toothpaste',
            'If strong smell, red gums, or drooling → Vet check needed',
            'If breath smells like urine → Could be kidney/liver issue – vet ASAP!'
          ],
          imagePath: 'assets/images/symptoms/bad_breath.jpg',
          emergencyLevel: 'mild',
        ),
        const PetSymptom(
          name: 'Excessive Drooling',
          description:
              'Some drooling is normal, but if your pet is suddenly dripping like a leaky faucet, it\'s a sign of a problem!',
          causes: [
            'Dental problem (infected tooth or gum disease)',
            'Mouth injury (something sharp stuck inside)',
            'Nausea or poisoning (if drooling & acting sick)',
            'Heatstroke (if panting & overheating)'
          ],
          actions: [
            'If mild & no other symptoms → Monitor & offer fresh water',
            'If bad smell, trouble eating, or blood → Vet visit needed',
            'If drooling with weakness or shaking → Emergency! Could be poisoning or heatstroke'
          ],
          imagePath: 'assets/images/symptoms/drooling.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Red, Swollen Gums',
          description: 'Healthy gums should be pink, not red or puffy!',
          causes: [
            'Gingivitis (early gum disease)',
            'Dental infection (from tartar buildup)',
            'Something stuck in gums (like a bone splinter)'
          ],
          actions: [
            'If mild redness → Brush teeth (with pet-safe toothpaste) & monitor',
            'If swollen, bleeding, or painful → Vet check needed'
          ],
          imagePath: 'assets/images/symptoms/swollen_gums.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Loose or Missing Teeth',
          description:
              'Puppies lose baby teeth, but adults shouldn\'t lose teeth!',
          causes: [
            'Puppy or kitten teething (normal under 6 months)',
            'Dental disease (if an adult pet loses teeth)',
            'Trauma (hit to the mouth, chewing something hard)'
          ],
          actions: [
            'If puppy or kitten → Totally normal, just monitor!',
            'If adult pet loses teeth → Vet check for gum disease',
            'If bleeding or painful → See a vet ASAP'
          ],
          imagePath: 'assets/images/symptoms/loose_teeth.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Trouble Eating or Dropping Food',
          description:
              'If your pet loves food but suddenly struggles to eat, check their mouth!',
          causes: [
            'Tooth pain or infection (hurts to chew)',
            'Mouth injury (cut, ulcer, or something stuck)',
            'Swollen gums (gingivitis or abscess)'
          ],
          actions: [
            'Check for anything stuck (hair, bone, wood)',
            'If eating slowly or avoiding hard food → Vet check for dental issues',
            'If bleeding or yelping → Vet ASAP'
          ],
          imagePath: 'assets/images/symptoms/trouble_eating.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Bleeding from the Mouth',
          description:
              'Seeing blood in your pet\'s mouth? It could be from the gums, teeth, or tongue — and it\'s important to find out why.',
          causes: [
            'Gum disease (common cause)',
            'Mouth injury (bit tongue, sharp object)',
            'Tooth infection (abscess or decay)'
          ],
          actions: [
            'If the bleeding is light and your pet is eating normally → Offer soft food and monitor closely',
            'If the bleeding is heavy, keeps coming back, or your pet is in pain → Go to the vet as soon as possible'
          ],
          imagePath: 'assets/images/symptoms/mouth_bleeding.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'White or Pale Gums',
          description:
              'Gums should be pink, not white or pale. This could mean serious illness!',
          causes: [
            'Anemia (low blood count) (due to illness or parasites)',
            'Shock or blood loss (from internal bleeding)',
            'Serious illness (kidney/liver disease, poisoning)'
          ],
          actions: ['Vet visit ASAP (this is an emergency!)'],
          imagePath: 'assets/images/symptoms/pale_gums.jpg',
          emergencyLevel: 'emergency',
        ),
        const PetSymptom(
          name: 'Locked Jaw (Mouth Won\'t Open or Close)',
          description:
              'If your pet can\'t open or close their mouth properly, something is seriously wrong!',
          causes: [
            'Injury or Fall – A hard hit or fall can damage the jaw (Common in cats!)',
            'Jaw Joint Problem – Dislocation or stiffness in the jaw joint',
            'Muscle or Nerve Issue – Some conditions weaken or stiffen the jaw muscle',
            'Severe Infection or Swelling – A bad tooth or swelling can make movement painful',
            'Tetanus (Lockjaw) – A bacterial infection causing stiff muscles'
          ],
          actions: [' Vet visit ASAP! This is an emergency.'],
          imagePath: 'assets/images/symptoms/locked_jaw.jpg',
          emergencyLevel: 'emergency',
        ),
        const PetSymptom(
          name: 'Oral Ulcers (Sores in the Mouth)',
          description:
              'Painful sores in the mouth can make eating difficult and may signal an infection!',
          causes: [
            'Feline Calicivirus – Common in cats, causes mouth ulcers & flu-like symptoms',
            'Severe Dental Disease – Advanced gum infections can lead to ulcers',
            'Toxic Ingestion – Licking chemicals, toxic plants, or medications',
            'Immune-Related Illness– Some immune disorders trigger mouth ulcers'
          ],
          actions: [
            'If the sore is small and your pet eats normally → Offer soft food and monitor closely',
            'If there\'s drooling, fever, or sneezing (especially in cats) → Vet check for possible infection like calicivirus',
            'If there\'s bleeding, bad breath, or your pet won\'t eat → Go to the vet as soon as possible'
          ],
          imagePath: 'assets/images/symptoms/oral_ulcers.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Yellow or Brown Teeth (Tartar Buildup)',
          description:
              'If your pet\'s teeth look like they need a deep clean, tartar buildup might be the problem!',
          causes: [
            'Plaque & tartar buildup (common in small dog breeds & older pets)',
            'Gingivitis (red gums with tartar)',
            'Tooth decay (if severe)'
          ],
          actions: [
            'If mild yellowing → Start brushing teeth regularly',
            'If heavy tartar & bad breath → Vet dental cleaning needed'
          ],
          imagePath: 'assets/images/symptoms/yellow_brown_teeth.jpg',
          emergencyLevel: 'mild',
        ),
        const PetSymptom(
          name: 'Tongue or Lip Swelling',
          description:
              'A swollen tongue or lips can mean an allergic reaction or something stuck!',
          causes: [
            'Allergic reaction (insect sting, food, or medication)',
            'Mouth injury (cut or something stuck)',
            'Infection or tumor (if long-term swelling)'
          ],
          actions: [
            'If sudden swelling → Vet ASAP (could be a serious allergy!)',
            'If mild & no breathing issues → Monitor & check for a stuck object'
          ],
          imagePath: 'assets/images/symptoms/tongue_lip_swelling.jpg',
          emergencyLevel: 'urgent',
        ),
      ],
    },
    'skin': {
      'Skin & Coat Symptoms': [
        const PetSymptom(
          name: 'Hair Loss',
          description:
              'Noticing more hair on the floor, couch, or your clothes?',
          causes: [
            'Normal Shedding – Some pets shed more in hot weather or certain seasons',
            'Poor Diet – Not enough good nutrients can lead to weak hair and extra shedding',
            'Stress – Pets may shed more when they\'re scared, anxious, or bored',
            'Hormonal Issues',
            'Fleas or Worms – Parasites can affect your pet\'s coat and overall health'
          ],
          actions: [
            'If hair loss is light and your pet seems fine → Brush regularly & keep a healthy diet',
            'If your pet hasn\'t had flea or worm prevention recently → Visit your vet to stay up to date on parasite protection',
            'If shedding is sudden and heavy → Get a vet check to rule out health issues',
            'If hair is falling out in patches or the coat looks thin → Vet visit needed to check deeper causes',
            'If skin looks red, scabby, or has sores → See your vet ASAP'
          ],
          imagePath: 'assets/images/symptoms/hair_loss.jpg',
          emergencyLevel: 'mild',
        ),
        const PetSymptom(
          name: 'Bald Spots (Patches of Missing Hair)',
          description:
              'Do you see one or more spots where your pet\'s fur is completely gone?',
          causes: [
            'Fungal Infection – A skin problem that causes round, bare spots (like ringworm)',
            'Allergies – To food, dust, grass, or something your pet touched',
            'Skin Infection – Bacteria or fungus can make the skin sore and cause hair to fall out',
            'Too Much Licking or Scratching – From pain, itching, or stress',
            'Irritation or Injury – From a tight collar, harness, or constant rubbing'
          ],
          actions: [
            'If the spot is small and your pet isn\'t licking or scratching → Watch it for a few days',
            'If your pet keeps licking, biting, or scratching the spot → Go to the vet to check the cause',
            'If the spot is round and flaky → It might be a fungal infection — ask your vet',
            'If the skin looks red, sore, or has scabs → Visit the vet as soon as possible'
          ],
          imagePath: 'assets/images/symptoms/bald_spots.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Itchy Skin (Scratching a Lot)',
          description:
              'A little scratching is normal, but too much means something\'s wrong!',
          causes: [
            'Fleas or Mites – Tiny parasites that cause intense itching',
            'Skin Infection – Bacteria or fungus can irritate the skin',
            'Allergies – Food, pollen, dust, or even shampoo!'
          ],
          actions: [
            'If your pet scratches once in a while and skin looks normal → Brush daily and keep an eye on it',
            'If scratching happens every day or all the time → Vet visit to check the causes',
            'If flea or tick prevention is overdue → See your vet to restart protection',
            'If your pet bites, licks, or cries while scratching → This means they\'re uncomfortable — visit the vet',
            'If skin is red, flaky, or fur is coming out → vet check needed'
          ],
          imagePath: 'assets/images/symptoms/itchy_skin.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Constant Licking in One Spot',
          description:
              'Your pet keeps licking or biting the same area over and over?',
          causes: [
            'Allergies – To food, fleas, grass, or dust',
            'Itching – From skin infections or bug bites',
            'Pain or Irritation – Like a small wound, or something stuck in the fur',
            'Stress or Boredom – Some pets lick themselves when anxious'
          ],
          actions: [
            'If the area looks a little pink → Keep it clean & dry, and watch closely',
            'If it\'s wet, red, or your pet won\'t leave it alone → Go to the vet before it gets worse',
            'If there\'s a strong smell, pus, or the spot is growing quickly → Go to the vet ASAP'
          ],
          imagePath: 'assets/images/symptoms/constant_licking.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Red or Inflamed Skin',
          description:
              'Is your pet\'s skin looking red, warm, or sore in some areas?',
          causes: [
            'Allergic Reaction – From food, shampoo, grass, dust, or something they touched',
            'Hot Spot – A red, wet, painful patch from too much licking or scratching',
            'Skin Infection – Caused by bacteria or fungus',
            'Sunburn – Pets with light skin or thin fur can burn easily in the sun'
          ],
          actions: [
            'If the redness is small and your pet isn\'t licking it → Keep the area clean and dry, and watch for changes',
            'If your pet is licking, scratching, or the area looks irritated → Vet visit needed to find the cause and stop the discomfort',
            'If the skin is very red, moist, or sticky → This could be an infection or hot spot — see your vet',
            'If the redness showed up after sun exposure → Move your pet out of the sun and go to the vet',
            'If the redness spreads, forms scabs, or has a bad smell → Go to the vet ASAP'
          ],
          imagePath: 'assets/images/symptoms/red_skin.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Dandruff (Flaky Skin)',
          description:
              'If your pet\'s fur has little white flakes, it might be dry skin or something more!',
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
          imagePath: 'assets/images/symptoms/dandruff.jpg',
          emergencyLevel: 'mild',
        ),
        const PetSymptom(
          name: 'Scabs or Crusty Skin',
          description:
              'Is your pet\'s skin rough in spots? Those might be scabs from too much scratching.',
          causes: [
            'Scratching or biting too much (due to fleas, allergies, or infections)',
            'Skin infection – Bacteria causing sores and crusty patches',
            'Mites (Mange) – Tiny bugs that irritate the skin and cause hair loss and scabs'
          ],
          actions: [
            'If your pet is scratching or biting often → Check for fleas (especially near the tail, belly, and armpits)',
            'If you see bugs, black dirt, or hair loss → Visit the vet for flea or mite treatment',
            'If scabs are spreading, red, or smell bad → Go to the vet',
            'Don\'t pick at scabs or apply creams without asking your vet'
          ],
          imagePath: 'assets/images/symptoms/scabs.jpg',
          emergencyLevel: 'moderate',
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
            'If the lump is soft, small, and not changing → Monitor it and mention it to your vet at the next visit',
            'If it\'s growing, feels hard, or painful → Vet visit needed'
          ],
          imagePath: 'assets/images/symptoms/lumps.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Skin Turning Darker (Hyperpigmentation)',
          description:
              'Noticing your pet\'s skin turning dark or black in some areas?',
          causes: [
            'Long-term irritation – From constant scratching, licking, or rubbing',
            'Skin allergies or infections – Ongoing skin problems can cause dark patches',
            'Hormone changes – Can sometimes affect skin color',
            'Normal aging – In some pets, skin gets darker as they grow older'
          ],
          actions: [
            'If the skin is darker but your pet acts normal → It may be harmless — just keep an eye on it',
            'If there\'s also itching, hair loss, or changes in appetite or weight → Vet check is needed',
            'If the dark skin looks rough, thick, or spreads over time → Go to the vet',
            'If your pet keeps licking or scratching the same spot → ask your vet for help'
          ],
          imagePath: 'assets/images/symptoms/dark_skin.jpg',
          emergencyLevel: 'mild',
        ),
      ],
    },
    'legs': {
      'Movement & Limbs Issues': [
        const PetSymptom(
          name: 'Limping or Favoring One Leg',
          description:
              'If your pet avoids putting weight on one leg, they might be in pain!',
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
          imagePath: 'assets/images/symptoms/limping.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Stiffness or Trouble Standing Up',
          description:
              'If your pet struggles to get up or moves stiffly, their joints or muscles might be sore.',
          causes: [
            'Arthritis – Joint pain, especially in older pets',
            'Muscle Soreness – After heavy play or running',
            'Hip or Spine Problems – Especially in large dog breeds',
            'Nerve Issue – If the back legs seem weak or unsteady',
            'Fall Injury – Can affect the spine, hips, or nerves'
          ],
          actions: [
            'Let your pet rest on a soft surface and avoid jumping or stairs',
            'If this happens once and improves quickly → Monitor for a day',
            'If it keeps happening, gets worse, or your pet seems in pain → Take them to the vet'
          ],
          imagePath: 'assets/images/symptoms/stiffness.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Sudden Weakness or Collapsing',
          description:
              'If your pet suddenly can\'t stand or falls over, it\'s an emergency!',
          causes: [
            'Heart Problem – Can cause fainting episodes',
            'Severe Pain or Injury – A hidden issue making them weak',
            'Low Blood Sugar (Hypoglycemia) – More common in small breeds',
            'Nerve or Brain Issue – Can affect balance and movement'
          ],
          actions: ['🚨 Take your pet to the vet immediately!'],
          imagePath: 'assets/images/symptoms/collapsing.jpg',
          emergencyLevel: 'emergency',
        ),
        const PetSymptom(
          name: 'Trembling or Shaking',
          description:
              'Shaking can mean pain, cold, or something more serious!',
          causes: [
            'Pain or Stress – If shaking happens with whining or hiding',
            'Cold (Hypothermia) – Especially in small or short-haired pets or wet',
            'Poisoning – If sudden shaking with vomiting or drooling',
            'Nerve Issue – If one leg or side shakes uncontrollably'
          ],
          actions: [
            'If your pet is cold → Warm them up with a blanket',
            'If shaking happens after stress or fear → Keep them calm and observe',
            'If shaking comes with vomiting, confusion, or weakness → Go to the vet immediately',
            'If it keeps happening or worsens → Vet check is needed'
          ],
          imagePath: 'assets/images/symptoms/trembling.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Swollen or Painful Joints',
          description:
              'If your pet\'s leg or joint looks swollen, something\'s not right!',
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
          imagePath: 'assets/images/symptoms/swollen_joints.jpg',
          emergencyLevel: 'moderate',
        ),
      ],
    },
    'buttocks': {
      'Anus & Pooping Issues': [
        const PetSymptom(
          name: 'Scooting or Dragging Butt on the Floor',
          description:
              'If your pet keeps sliding their butt on the floor, they might be itchy or uncomfortable!',
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
          imagePath: 'assets/images/symptoms/scooting.jpg',
          emergencyLevel: 'mild',
        ),
        const PetSymptom(
          name: 'Swelling or Redness Around the Anus',
          description:
              'Noticed your pet\'s butt looks red, swollen, or something\'s sticking out? It could be irritation — or a sign something more serious is going on.',
          causes: [
            'Anal Gland Problem – Swollen or infected glands near the anus',
            'Allergic Reaction – To food, fleas, or cleaning products',
            'Straining or Constipation – Can cause swelling or even a little bleeding',
            'Rectal Prolapse – When part of the rectum pushes out through the anus. It looks like a red or pink tube and needs urgent vet care'
          ],
          actions: [
            'If the area is just a bit red and your pet acts normal → Gently clean and monitor',
            'If it\'s swollen, painful, or your pet keeps licking or scooting → Vet check needed soon',
            'If you see a pink or red part sticking out of the anus → go to the vet immediately',
            'Don\'t try to push anything back in or use home creams — this could make it worse'
          ],
          imagePath: 'assets/images/symptoms/anal_swelling.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Blood in Stool or Around the Anus',
          description:
              'Noticed blood when your pet poops or around their butt?',
          causes: [
            'Small Tear from Straining – Often from hard or dry poop',
            'Worms or Parasites',
            'Anal Gland Infection – Can cause bleeding if severe',
            'More Serious Problems – Like colitis, tumors, or poisoning'
          ],
          actions: [
            'If it\'s just a small streak of blood and your pet seems fine → Monitor closely and offer your pet fresh water',
            'If blood is fresh and keeps appearing, or if your pet also has diarrhea → Vet check recommended soon',
            'If there\'s a lot of blood, your pet is weak, vomiting, or not eating → Go to the vet immediately — emergency'
          ],
          imagePath: 'assets/images/symptoms/blood_stool.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Straining to Poop or Constipation',
          description:
              'If your pet keeps trying to poop but nothing comes out?',
          causes: [
            'Not Drinking Enough Water – Leads to hard, dry poop',
            'Hairballs (in cats) – Can slow or block the intestines',
            'Eating Bones or Foreign Objects – Can cause a blockage',
            'Anal Gland Problem – Painful glands can make pooping hard',
            'Serious Problems – If straining also comes with vomiting, bloating'
          ],
          actions: [
            'Offer more water & add fiber (mashed boiled potatoes or carrots can help)',
            'If straining lasts more than a day, or your pet seems in pain → Vet visit needed',
            '⚠️ Important: Straining to poop can sometimes be confused with straining to pee, especially in male cats — which can be fatal'
          ],
          imagePath: 'assets/images/symptoms/straining_poop.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Diarrhea',
          description:
              'Loose, watery poop? It might be something simple or more serious!',
          causes: [
            'Diet Change or Eating Something Bad – Common cause of mild diarrhea',
            'Worms or Infections',
            'Stress or Anxiety – Can cause tummy issues',
            'Serious Illness – If diarrhea is bloody or long-lasting'
          ],
          actions: [
            'Give bland food (boiled chicken & rice)',
            'Keep your pet hydrated —dehydration is a major risk and can be life-threatening!',
            'If diarrhea lasts more than two days, has blood, or pet is weak → Vet check needed'
          ],
          imagePath: 'assets/images/symptoms/diarrhea.jpg',
          emergencyLevel: 'moderate',
        ),
      ],
    },
    'pelvis': {
      'Male Genital Problems': [
        const PetSymptom(
          name: 'Swollen Testicles',
          description:
              'If your pet\'s testicles look bigger than usual, something\'s up!',
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
          imagePath: 'assets/images/symptoms/swollen_testicles.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Discharge from the Penis',
          description:
              'A small amount of pale yellow or clear fluid can be normal, but heavy or smelly discharge is not.',
          causes: [
            'Normal Fluid – A small amount of pale yellow or clear discharge that appears occasionally',
            'Infection – Thick, smelly, or green discharge may mean bacteria are present',
            'Injury or Irritation – From licking, rubbing, or minor trauma',
            'Prostate Problems – More common in older, unneutered dogs'
          ],
          actions: [
            'If it\'s just a little pale yellow or clear fluid and your pet seems fine → Usually normal, gently wipe it away',
            'If it\'s thick, smelly, green, or there\'s a lot → Vet visit needed',
            'If your pet is licking the area constantly or straining to pee → Vet check recommended'
          ],
          imagePath: 'assets/images/symptoms/penis_discharge.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Red, Swollen, or Hanging Out Penis',
          description:
              'If your pet\'s penis won\'t go back inside, it\'s an emergency!',
          causes: [
            'Hair or dirt stuck, preventing retraction',
            'Nerve damage or trauma',
            'Infection or inflammation'
          ],
          actions: [
            'If mild swelling, but retracts → Vet visit soon',
            'If penis stays out, red, or swollen → Emergency! Wrap in a damp cloth & go to vet immediately!'
          ],
          imagePath: 'assets/images/symptoms/exposed_penis.jpg',
          emergencyLevel: 'emergency',
        ),
        const PetSymptom(
          name: 'Lumps or Bleeding from the Genitals',
          description:
              'If you notice a lump, sore, or bleeding around your pet\'s genitals, don\'t ignore it!',
          causes: [
            'Infection – bacterial or fungal infection',
            'Injury or Irritation – From rough surfaces, excessive licking, or trauma',
            'Tumor or Growth – Some lumps are harmless, but others need treatment',
            'TVT (Transmissible Venereal Tumor) – A contagious cancer spread between dogs, common in strays and unneutered pets'
          ],
          actions: [
            'If it\'s a small, soft lump that isn\'t growing and your pet seems comfortable → Prevent licking and monitor for 24 hours',
            'If the lump is red, growing, or bleeding → Vet visit ASAP!',
            'If your pet had contact with stray dogs → Get them checked, could be TVT'
          ],
          imagePath: 'assets/images/symptoms/genital_lumps.jpg',
          emergencyLevel: 'urgent',
        ),
      ],
      'Female Genital Problems': [
        const PetSymptom(
          name: 'Swollen Vulva',
          description:
              'If your pet\'s vulva looks swollen, it might be a natural part of her cycle—or a health issue!',
          causes: [
            'Normal Heat Cycle – If your pet isn\'t spayed, swelling with mild clear discharge and behavior changes is normal during heat',
            'Infection – If swelling comes with discharge or excessive licking',
            'Allergic reaction – From food, grass, or cleaning products',
            'Trauma or irritation – From excessive licking or rough surfaces'
          ],
          actions: [
            'Check for heat signs → If swelling comes with behavioral changes (restlessness, attracting male dogs, or spotting blood), it\'s likely normal heat',
            'If unsure → Monitor for 2–3 days; if swelling worsens or there\'s discharge, see a vet',
            'If swelling is sudden, severe, or painful → Vet visit needed'
          ],
          imagePath: 'assets/images/symptoms/swollen_vulva.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Discharge from the Vulva',
          description:
              'A little clear or whitish discharge is normal, but anything smelly or unusual isn\'t normal!',
          causes: [
            'Normal Heat Cycle – If your pet isn\'t spayed, a small amount of clear discharge is expected',
            'Infection – Bacteria can cause irritation and unusual discharge',
            'Serious Uterus Infection! – In unspayed pets this is called pyometra, and it\'s an emergency. It can also happen in recently spayed pets (stump pyometra)',
            'Tumors or Growths – Less common, but possible in older pets'
          ],
          actions: [
            'If clear discharge with no smell & pet seems fine and eating → normal, especially if in heat',
            'If thick, yellow, green, or smelly discharge → Vet visit ASAP!',
            'If your pet is weak, not eating, has a swollen belly or drinking lots of water → Emergency!'
          ],
          imagePath: 'assets/images/symptoms/vulva_discharge.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Something Sticking Out from the Vulva',
          description:
              'If you see a pink, red, or dark lump/tissue coming out of your pet\'s vulva, it\'s serious!',
          causes: [
            'Straining During Birth – Can push tissue out (prolapse)',
            'Weak Pelvic Muscles – More common in older pets',
            'Injury or Hormonal Issues – Can lead to tissue slipping out',
            'After Giving Birth – Could be placenta or fetal membranes stuck, or a prolapse starting — both are emergencies'
          ],
          actions: [
            'Do NOT try to push anything back in',
            'Keep the area clean and moist (use a clean, damp cloth)',
            'If just after giving birth → Still treat as urgent; retained placenta can cause deadly infection and prolapse can worsen fast',
            'Emergency vet visit needed!'
          ],
          imagePath: 'assets/images/symptoms/vulva_prolapse.jpg',
          emergencyLevel: 'emergency',
        ),
      ],
      'Urination Problems': [
        const PetSymptom(
          name: 'Peeing Too Much (Frequent Urination)',
          description:
              'If your pet is peeing much more than usual, even in small amounts, it could be a sign of illness.',
          causes: [
            'Bladder Infection (UTI) – Can cause frequent, sometimes painful peeing',
            'Diabetes or Kidney Problems – Often comes with drinking more water',
            'Hormonal Problems – Can affect urine control',
            'Anxiety or Excitement – Can cause nervous peeing'
          ],
          actions: [
            'If drinking a lot more water than usual → Vet check to rule out diabetes or kidney issues',
            'If peeing often + straining, blood, or peeing in the wrong places → Could be a UTI or bladder issue; go to the vet',
            'If no other symptoms and your pet acts normal → Monitor closely for 24 hours; if it continues, see a vet',
            '⚠ Important: In male cats, frequent trips to the litter box with only small drops of urine could be a urinary blockage — a life-threatening emergency. Go to the vet clinic immediately'
          ],
          imagePath: 'assets/images/symptoms/frequent_urination.jpg',
          emergencyLevel: 'moderate',
        ),
        const PetSymptom(
          name: 'Straining to Pee (Difficulty Urinating)',
          description:
              'If your pet squats for a long time but only a few drops—or nothing—comes out, it\'s a red flag!',
          causes: [
            'Bladder Infection (UTI) – Can make peeing painful and difficult',
            'Bladder Stones – Can block urine flow or cause irritation',
            'Urinary Blockage – Life-threatening emergency',
            'Prostate Problems – Can put pressure on the bladder and block urine'
          ],
          actions: [
            'If straining + only small drops → Vet visit needed (possible infection or stones)',
            'If trying to pee but nothing comes out → 🚨 Emergency! A blockage can kill a male cat within 1–2 days',
            'If straining + blood in urine → Go to the vet'
          ],
          imagePath: 'assets/images/symptoms/straining_urination.jpg',
          emergencyLevel: 'emergency',
        ),
        const PetSymptom(
          name: 'Bloody Urine (Red or Pink Pee)',
          description:
              'If your pet\'s pee looks red or pink, don\'t ignore it!',
          causes: [
            'Urinary tract infection (UTI) – Can cause irritation and bleeding',
            'Bladder Stones – Hard mineral build-up in the bladder that can cause irritation and bleeding',
            'Tumors in the Bladder or Urinary Tract – More common in older pets',
            'Injury or Trauma – A fall or accident could cause internal bleeding'
          ],
          actions: [
            'If bloody urine + frequent peeing or straining → Vet visit ASAP! Could be an infection or stones',
            'If blood appears once but your pet acts normal → Monitor closely, but if happens again go to the vet',
            'If your pet was recently injured or fell from a height → Vet check needed to rule out internal damage'
          ],
          imagePath: 'assets/images/symptoms/bloody_urine.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Not Peeing at All (Emergency!)',
          description:
              'If your pet hasn\'t peed in over 24 hours, it\'s a life-threatening emergency!',
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
          imagePath: 'assets/images/symptoms/no_urination.jpg',
          emergencyLevel: 'emergency',
        ),
      ],
    },
    // Add more body parts and symptoms as needed
  };

  /// Get all symptoms as a flat list for search functionality
  static List<PetSymptom> getAllSymptoms() {
    final List<PetSymptom> allSymptoms = [];
    symptoms.forEach((bodyPart, categories) {
      categories.forEach((category, symptomList) {
        allSymptoms.addAll(symptomList);
      });
    });
    return allSymptoms;
  }

  /// Get symptoms by emergency level
  static List<PetSymptom> getSymptomsByEmergencyLevel(String emergencyLevel) {
    final allSymptoms = getAllSymptoms();
    return allSymptoms
        .where((symptom) =>
            symptom.emergencyLevel?.toLowerCase() ==
            emergencyLevel.toLowerCase())
        .toList();
  }

  /// Get emergency symptoms (urgent + emergency)
  static List<PetSymptom> getEmergencySymptoms() {
    final allSymptoms = getAllSymptoms();
    return allSymptoms
        .where((symptom) =>
            symptom.emergencyLevel?.toLowerCase() == 'emergency' ||
            symptom.emergencyLevel?.toLowerCase() == 'urgent')
        .toList();
  }

  static Map<String, Map<String, List<Map<String, dynamic>>>> getSymptomMaps() {
    final result = <String, Map<String, List<Map<String, dynamic>>>>{};

    symptoms.forEach((bodyPart, categories) {
      result[bodyPart] = {};
      categories.forEach((category, symptomList) {
        result[bodyPart]![category] =
            symptomList.map((symptom) => symptom.toMap()).toList();
      });
    });

    return result;
  }
}
