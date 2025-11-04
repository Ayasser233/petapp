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
      case 'Neurological Issues':
        return localizations?.neurologicalIssues ?? 'Neurological Issues';
      case 'Behavioral Issues':
        return localizations?.behavioralIssues ?? 'Behavioral Issues';
      case 'General Issues':
        return localizations?.generalIssues ?? 'General Issues';
      case 'Breathing Problems':
        return localizations?.breathingProblems ?? 'Breathing Problems';

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
            'Check the area first — if something is stuck, gently clean it and see if the scooting stops',
            'If scooting + licking the area → Could be full anal glands, vet can help',
            'Check for worms (look for small rice-like pieces near the butt)',
            'Make sure your pet is up to date on deworming',
            'If scooting continues or there\'s swelling → Vet check needed'
          ],
          imagePath: 'assets/images/symptoms/scooting.jpg',
          emergencyLevel: 'normal',
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
          name: 'Bloody Poop (Red or Black Stools)',
          description:
              'If you see red or black in your pet\'s poop, don\'t ignore it!',
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
            'If constipation lasts more than 48 hours → Vet check needed to prevent serious blockage',
            'If straining but no poop comes out at all → Could be a blockage, urgent vet visit!',
            '⚠️ Important: Straining to poop can sometimes be confused with straining to pee, especially in male cats — which can be fatal. Go to "Straining to Pee" under Urination Problems for urgent guidance'
          ],
          imagePath: 'assets/images/symptoms/straining_poop.jpg',
          emergencyLevel: 'normal',
        ),
        const PetSymptom(
          name: 'Diarrhea',
          description:
              'Loose, watery poop? It might be something simple or more serious!',
          causes: [
            'Ate something bad (trash, spoiled food, new food)',
            'Worms or parasites',
            'Infections (from bacteria or viruses)',
            'Food allergies or change in diet',
            'Stress or anxiety',
            'More serious problems (like pancreas or liver issues)'
          ],
          actions: [
            'If diarrhea happens once or twice but your pet is acting normal → Try a bland diet (boiled chicken & rice) and watch for 24 hours',
            'If diarrhea lasts more than two days, has blood, or comes with vomiting/lethargy → Vet visit needed! Could be serious',
            'If your pet is very young or small breed → Don\'t wait! Diarrhea can cause dehydration fast'
          ],
          imagePath: 'assets/images/symptoms/diarrhea.jpg',
          emergencyLevel: 'normal',
        ),
        const PetSymptom(
          name: 'No Pooping at All (Emergency!)',
          description:
              'If your pet hasn\'t pooped in more than 3 days, they could be blocked!',
          causes: [
            'Severe constipation or something blocking the intestines',
            'Swallowed objects (toys, bones, hair, string)',
            'Nerve issues affecting bowel movement (like spinal problems)'
          ],
          actions: [
            'If no poop for over 3 days → Vet visit ASAP! Don\'t wait, it could be serious',
            'If your pet is trying to poop but nothing comes out + shows pain → Emergency! Could be a blockage',
            'If your pet may have swallowed something (string, fabric, bones) → Get to a vet right away!'
          ],
          imagePath: 'assets/images/symptoms/no_poop.jpg',
          emergencyLevel: 'emergency',
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
    'neurological': {
      'Neurological Issues': [
        const PetSymptom(
          name: 'Seizures',
          description:
              'If your pet suddenly starts shaking, drooling, or falling over, they might be having a seizure!',
          causes: [
            'Epilepsy (some pets are born with it)',
            'Poisoning (chocolate, human meds)',
            'Head injury',
            'Liver or kidney problems',
            'Low blood sugar',
            'Brain tumors (rare)'
          ],
          actions: [
            'Stay calm – Don\'t try to hold them down',
            'Keep them safe – Move objects away so they don\'t get hurt',
            'Don\'t feed or give water until your pet is fully back to normal',
            'Time the seizure – If over 2 minutes → Emergency',
            'Record a video if safe – Helps the vet with diagnosis',
            'After the seizure – Keep your pet quiet and comfortable; once they\'re alert, offer water',
            'Go to the vet if: The seizure lasts more than 2 minutes, They have more than one seizure in 24 hours, They don\'t recover quickly or seem very weak',
            'Only go to the vet once the seizure has stopped (never try to move them mid-seizure)'
          ],
          imagePath: 'assets/images/symptoms/seizures.jpg',
          emergencyLevel: 'emergency',
        ),
        const PetSymptom(
          name: 'Head Tilt or Walking in Circles',
          description:
              'If your pet keeps tilting their head to one side or walks in circles, something might be wrong with their brain or inner ear!',
          causes: [
            'Ear infection – A common cause, especially if there\'s scratching or a bad smell',
            'Balance problems in older pets',
            'Toxins or certain medications',
            'Brain issues (tumor or injury) – Less common'
          ],
          actions: [
            'If it just started and your pet seems normal otherwise → Monitor closely for the next 24 hours',
            'Check the ears – If there\'s redness, swelling, or a bad smell, it could be an ear infection → Vet visit needed',
            'If no signs of an ear infection but symptoms continue → Could be neurological, see a vet',
            'If the tilt continues or gets worse → Book a vet visit',
            'If your pet is falling, walking in circles, or has trouble standing → Go to the vet immediately'
          ],
          imagePath: 'assets/images/symptoms/head_tilt.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Loss of Balance',
          description:
              'If your pet suddenly stumbles, wobbles, or falls, it could be a sign of something serious!',
          causes: [
            'Poisoning – Chocolate, onions, human medicine',
            'Ear Infection – Can affect balance and coordination',
            'Balance Problems in Older Pets – Age-related changes',
            'Spinal Injury – Trauma affecting nerves or movement',
            'Stroke – Sudden loss of balance or weakness',
            'Neurological Disease – Brain or nerve issues'
          ],
          actions: [
            'If your pet is a little wobbly but still alert and walking → Monitor closely for a few hours',
            'If your pet can\'t stand at all or keeps falling → Emergency vet visit immediately',
            'If balance issues come with vomiting or head tilt → Vet check ASAP',
            'If you suspect poisoning → Emergency vet immediately!'
          ],
          imagePath: 'assets/images/symptoms/loss_of_balance.jpg',
          emergencyLevel: 'emergency',
        ),
        const PetSymptom(
          name: 'Sudden Blindness',
          description:
              'If your pet suddenly starts bumping into walls, seems lost in familiar places, or their pupils stay very wide, they may have lost vision suddenly.',
          causes: [
            'High blood pressure – Very common in older cats',
            'Retinal detachment – Can happen suddenly and cause blindness',
            'Diabetes complications – May damage the eyes over time',
            'Brain problems – Stroke or tumor (less common)',
            'Eye disease – Glaucoma (painful pressure) or cataracts (cloudy lens)'
          ],
          actions: [
            'If vision loss is gradual → Book a vet visit soon for an eye exam',
            'If vision loss is sudden (bumping into walls, not recognizing people/objects) → Vet visit ASAP! Quick treatment (especially for high blood pressure) can sometimes save vision',
            'If pupils are stuck wide open and don\'t react to light → Emergency vet visit immediately'
          ],
          imagePath: 'assets/images/symptoms/sudden_blindness.jpg',
          emergencyLevel: 'emergency',
        ),
        const PetSymptom(
          name: 'Sudden Collapse or Fainting',
          description:
              'If your pet suddenly falls down and seems unconscious, even if just for a moment, it\'s always a red flag.',
          causes: [
            'Heart disease – Can cause sudden fainting or collapse',
            'Anemia – Low blood levels make pets weak and collapse easily',
            'Low blood sugar – Common in small or diabetic pets',
            'Heatstroke – Especially after being outside in hot weather',
            'Poisoning – From toxic food, medications, or chemicals'
          ],
          actions: [
            'If collapse happened but your pet got up quickly → Still see a vet soon to find the cause',
            'If collapse + pale gums, weak pulse, or trouble breathing → Emergency vet immediately!',
            'If they were outside in heat before collapsing → Move to a cool area, offer small sips of water, and get to the vet right away',
            'If collapse happens more than once, or your pet doesn\'t recover quickly → Emergency vet ASAP'
          ],
          imagePath: 'assets/images/symptoms/sudden_collapse.jpg',
          emergencyLevel: 'emergency',
        ),
        const PetSymptom(
          name: 'Tremors',
          description:
              'If your pet is shaking or shivering while awake (not a seizure), there could be several reasons.',
          causes: [
            'Cold or fear – Cold weather, fear or stress can cause shaking',
            'Pain – From injuries, arthritis, or discomfort',
            'Low blood sugar – More likely in small dogs or sick pets',
            'Poisoning – Chocolate, meds, or toxic products',
            'Brain or nerve problems'
          ],
          actions: [
            'If your pet is just cold or scared but otherwise normal → Warm them up and keep them calm',
            'If shaking comes with vomiting, drooling, or weakness → Could be poisoning → Vet immediately',
            'If shaking continues for no clear reason, or comes with pain → Vet visit recommended to check the cause'
          ],
          imagePath: 'assets/images/symptoms/tremors.jpg',
          emergencyLevel: 'urgent',
        ),
      ],
    },
    'behavioral': {
      'Behavioral Issues': [
        const PetSymptom(
          name: 'Aggression (Growling, Biting, Hissing, Snapping)',
          description:
              'If your pet suddenly becomes aggressive, they might be in pain, scared, or feeling unwell!',
          causes: [
            'Pain or illness (arthritis, injury, infections)',
            'Fear or past trauma (especially in rescue pets)',
            'Territorial behavior (protecting food, toys, or space)',
            'Lack of socialization (not used to people or other animals)',
            'Hormones (common in unneutered males)',
            'Rabies or neurological issues (rare, but possible — especially if unvaccinated or bit by a stray)'
          ],
          actions: [
            'Rule out pain – If aggression is new, check for injuries and see a vet',
            'Avoid punishment – This can make it worse; use calm, positive reinforcement instead',
            'Give space – Don\'t force interaction if your pet seems scared or anxious',
            'Consider spaying/neutering – Can help reduce hormone-related aggression',
            'If aggression is sudden and extreme, and your pet is unvaccinated, or has been bitten by a stray/wild animal → See a vet immediately to rule out serious causes like rabies'
          ],
          imagePath: 'assets/images/symptoms/aggression.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Excessive Meowing / Barking / Howling',
          description:
              'If your pet is being unusually noisy, they may be hungry, stressed, or even unwell.',
          causes: [
            'Hunger or attention-seeking – Some breeds are naturally more vocal',
            'Pain or discomfort – Crying out if something hurts',
            'Anxiety or stress – Separation anxiety or changes at home',
            'Mating behavior – Common in unneutered pets'
          ],
          actions: [
            'Check the basics → Food, water, bathroom, or playtime',
            'If the noise is new or unusual → Rule out pain with a vet check',
            'If stress-related → Create a calm, stable environment',
            'If linked to mating behavior → Talk to your vet about spaying/neutering'
          ],
          imagePath: 'assets/images/symptoms/barking.jpg',
          emergencyLevel: 'normal',
        ),
        const PetSymptom(
          name: 'Hiding or Avoiding People',
          description:
              'If your pet suddenly hides, it\'s their way of showing something isn\'t right.',
          causes: [
            'Illness or pain – A very common reason for sudden hiding',
            'Fear or stress – New home, loud noises, visitors, or other pets',
            'Past trauma – Especially in rescue or abused animals',
            'Pregnancy (females) – Cats and dogs often hide before giving birth'
          ],
          actions: [
            'If it\'s just occasional hiding → Give them space, don\'t force them out',
            'If it happens with loud noises, visitors, or new changes → Likely stress; create a quiet, safe spot',
            'If hiding is new and comes with less eating, grooming, or play → Vet check needed to rule out illness',
            'If your female pet is unspayed and hiding with a swollen belly or nesting behavior → Could be pregnancy, monitor and prepare for birth, vet visit if unsure'
          ],
          imagePath: 'assets/images/symptoms/hiding.jpg',
          emergencyLevel: 'normal',
        ),
        const PetSymptom(
          name:
              'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)',
          description:
              'If your pet keeps chewing or swallowing things that aren\'t food, it may point to an underlying problem.',
          causes: [
            'Nutritional deficiencies – Missing important vitamins or minerals',
            'Boredom or stress – Pets may chew when frustrated or anxious',
            'Teething – Puppies and kittens chew to ease gum discomfort'
          ],
          actions: [
            'Check diet → Make sure your pet is getting balanced nutrition',
            'Provide safe chew toys → Give them proper chew sticks or toys instead of random objects',
            'Redirect gently → If you catch them chewing something unsafe, calmly replace it with a safe option',
            'If they often eat non-food items, or swallow dangerous things → Vet check needed to rule out deficiencies or health problems'
          ],
          imagePath: 'assets/images/symptoms/chewing.jpg',
          emergencyLevel: 'normal',
        ),
        const PetSymptom(
          name: 'Excessive Licking or Tail-Chasing',
          description:
              'If your pet is constantly licking their paws or chasing their tail, it\'s usually more than just play.',
          causes: [
            'Allergies or skin irritation – A very common reason for nonstop licking',
            'Pain – Arthritis or joint issues can make pets lick sore spots',
            'Anxiety or compulsive habits – Especially in high-energy or bored pets',
            'Parasites – Fleas, ticks, or skin mites can cause nonstop itching'
          ],
          actions: [
            'Check for redness, sores, or swelling → Could be infection or allergy',
            'Look for fleas or ticks in the fur → Treat if found',
            'Increase play and exercise → Helps with boredom or stress',
            'If licking or tail-chasing is nonstop to the point it causes skin wounds → Vet visit needed'
          ],
          imagePath: 'assets/images/symptoms/licking.jpg',
          emergencyLevel: 'normal',
        ),
        const PetSymptom(
          name: 'Loss of Interest in Playing or Interacting',
          description:
              'If your usually playful pet suddenly isn\'t interested in play or people, it could be a sign something\'s wrong.',
          causes: [
            'Pain or illness – Arthritis, dental problems, fever, or other hidden issues',
            'Stress or depression – Big changes at home, loss of a companion',
            'Aging – Pets often become less active and playful as they get older'
          ],
          actions: [
            'Watch for illness signs → Weight loss, not eating, limping, or fever → Vet visit needed',
            'Try new toys or gentle activities → Sometimes boredom or stress plays a role',
            'For senior pets → Gentle exercise, easy play, and more rest help keep them comfortable'
          ],
          imagePath: 'assets/images/symptoms/no_interest.jpg',
          emergencyLevel: 'normal',
        ),
      ],
    },
    'general': {
      'General Issues': [
        const PetSymptom(
          name: 'Vomiting',
          description:
              'A single vomit isn\'t always bad, but frequent vomiting is a warning sign!',
          causes: [
            'Eating too fast or too much',
            'Sudden diet change or spoiled food',
            'Hairballs (especially in cats)',
            'Parasites or stomach infections',
            'Poisoning (From toxic food, medications, or chemicals)',
            'Organ disease (liver, kidneys, stomach issues)',
            'Infection (virus or bacteria)'
          ],
          actions: [
            'One-time vomit & pet seems normal → Monitor closely, offer small portions of food and water later',
            'Repeated vomiting (more than 2–3 times in 24 hrs) → Vet visit needed',
            'Vomiting + diarrhea in a young pet → Emergency vet immediately',
            'Vomiting + blood, weakness, or pale gums → Emergency vet immediately (possible poisoning or serious illness)',
            'If caused by eating too fast → Offer smaller meals in portions instead of one big meal',
            'If vomiting once daily but persists for several days → Book a vet check to rule out chronic issues'
          ],
          imagePath: 'assets/images/symptoms/vomiting.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Regurgitation (Throwing Up Undigested Food)',
          description:
              'Vomiting and regurgitation aren\'t the same—regurgitation happens shortly after eating',
          causes: [
            'Eating too fast (common in greedy eaters)',
            'Esophagus issues',
            'Foreign object stuck'
          ],
          actions: [
            'If it happens rarely → Try feeding smaller portions or raising the bowl slightly',
            'If frequent or weight loss → Vet check-up needed',
            'If choking or difficulty swallowing → Emergency vet visit!'
          ],
          imagePath: 'assets/images/symptoms/regurgitation.jpg',
          emergencyLevel: 'normal',
        ),
        const PetSymptom(
          name: 'Loss of Appetite',
          description:
              'Skipping one meal isn\'t alarming, but not eating at all for 24+ hours? That\'s serious!',
          causes: [
            'Stress or anxiety (new environment, new pet, loud noises)',
            'Dental pain (bad teeth, infections)',
            'Fever, illness, or pain anywhere in the body',
            'Serious conditions (liver/kidney failure, cancer, infections)'
          ],
          actions: [
            'If your pet skips one meal but eats later → Monitor, could be stress or minor stomach upset',
            'Try offering warmed food, wet food, or their favorite treat → Sometimes this encourages eating',
            'Check their mouth for broken teeth, red gums, or bad smell → Painful mouths make pets stop eating',
            'If appetite loss continues for more than 24 hours, or comes with vomiting, weakness, or weight loss → Vet visit needed',
            'If your pet refuses all food + water, or also has fever, collapse, or bloated belly → Emergency vet immediately'
          ],
          imagePath: 'assets/images/symptoms/loss_appetite.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Sudden Weight Loss or Weight Gain',
          description:
              'If your pet\'s weight changes quickly without a change in diet or exercise, there may be an underlying reason.',
          causes: [
            'Weight Loss: Worms or parasites',
            'Weight Loss: Diabetes or thyroid problems',
            'Weight Loss: Chronic illness (kidney, liver, or cancer)',
            'Weight Loss: Poor appetite or food not being absorbed properly',
            'Weight Gain: Overfeeding or not enough exercise',
            'Weight Gain: Hormonal disorders',
            'Weight Gain: Fluid buildup (can be a sign of heart or liver disease)'
          ],
          actions: [
            'If eating normally but losing weight → Book a routine vet check to rule out parasites, diabetes, or other illness',
            'If appetite is poor and weight is dropping quickly → Vet visit soon, especially if it continues for more than a couple of days',
            'If gradual weight gain with no other issues → Review food portions & exercise. Adjust diet if needed',
            'If sudden weight gain or swollen belly → Vet check recommended (could be fluid or hormone-related)',
            'Always check your pet\'s deworming and insect prevention dates — overdue treatments can cause weight and health changes'
          ],
          imagePath: 'assets/images/symptoms/weight_change.jpg',
          emergencyLevel: 'normal',
        ),
        const PetSymptom(
          name: 'Fever (Hot Ears, Nose, or Body)',
          description: 'If your pet feels unusually hot, it could mean fever.',
          causes: [
            'Infections (bacterial, viral, or fungal)',
            'Inflammation from injury or illness',
            'Serious conditions (immune diseases, poisoning, cancer)'
          ],
          actions: [
            'Look for other signs: low energy, loss of appetite, shivering, or warm ears',
            'If mild warmth but your pet is eating, drinking, and active → Monitor closely',
            'If very warm + tired, not eating, or shivering → Vet check needed',
            'If your pet seems weak, vomiting, or breathing fast → Vet visit ASAP',
            'Never give human fever meds — they are deadly for pets!'
          ],
          imagePath: 'assets/images/symptoms/fever.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Lethargy (Weakness, Sleeping Too Much)',
          description:
              'If your normally active pet suddenly seems tired or weak, it could be anything from a lazy day to something more serious.',
          causes: [
            'Just having a lazy day (especially after lots of play or hot weather)',
            'Pain or discomfort (arthritis, injuries, tummy upset)',
            'Infections or fever',
            'Serious conditions: poisoning, organ disease, or internal bleeding'
          ],
          actions: [
            'If your pet is simply resting more than usual but still eats, drinks, and plays a bit → Probably just a lazy day, no need to worry',
            'If lethargy comes with vomiting, diarrhea, limping, or not eating → Book a vet visit soon',
            'If your pet is very weak, collapses, or refuses food & water → Emergency vet immediately'
          ],
          imagePath: 'assets/images/symptoms/lethargy.jpg',
          emergencyLevel: 'normal',
        ),
      ],
    },
    'breathing': {
      'Breathing Problems': [
        const PetSymptom(
          name: 'Heavy Panting',
          description:
              'Panting after play or heat is normal — but panting while resting, or for no reason, can be a red flag.',
          causes: [
            'Overheating / Heatstroke – Can happen in hot weather, inside cars, or after too much activity',
            'Flat-Faced Breeds (Bulldogs, Pugs, Frenchies, etc.) – These dogs have narrow airways, making it harder to breathe and cool down, so they pant heavily even without heat',
            'Pain or Stress – Pets may pant when they\'re uncomfortable or anxious',
            'Heart or Lung Disease – Fluid or illness can make breathing difficult',
            'Obesity – Extra weight makes it harder to cool down'
          ],
          actions: [
            'If panting is from heat → Move them to a cool place and offer small amounts of water',
            'If your dog is a flat-faced breed → Be extra cautious. Avoid hot weather, overexertion, and stressful play. If panting seems extreme, noisy, or happens even at rest → Book a vet visit',
            'If your pet is panting at rest, or it comes with coughing, weakness, or restlessness → Vet visit needed',
            'If panting + collapse, very pale/blue gums, or severe distress → Emergency vet immediately!'
          ],
          imagePath: 'assets/images/symptoms/panting.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Coughing',
          description:
              'A little cough now and then is usually nothing, but frequent or harsh coughing can mean trouble!',
          causes: [
            'Mild throat irritation – From dust, pulling on the leash, or excitement',
            'Infectious cough (kennel cough) – A contagious condition that spreads easily between dogs',
            'Heart problems – Can cause nighttime coughing or coughing after exercise',
            'Lung infection – often with fever or weakness',
            'Allergies or asthma – Can cause ongoing coughing or wheezing',
            'Collapsed airway – causes a honking cough'
          ],
          actions: [
            'If the cough is rare and mild (like after running or pulling on leash) → Normal',
            'If the cough keeps coming back for more than 2 days or gets worse → Vet visit needed',
            'If coughing comes with fever, not eating, or low energy → Book a vet check soon',
            'If your pet struggles to breathe, has blue gums, or collapses → Emergency vet immediately',
            'If coughing happens right after eating or drinking → Could be a swallowing or airway issue → Vet check recommended'
          ],
          imagePath: 'assets/images/symptoms/coughing.jpg',
          emergencyLevel: 'normal',
        ),
        const PetSymptom(
          name: 'Wheezing or Noisy Breathing',
          description:
              'If your pet sounds like they\'re struggling for air, it could be from a blocked or narrowed airway.',
          causes: [
            'Mild respiratory infection (like cat flu or infectious cough in dogs)',
            'Asthma (more common in cats)',
            'Allergic reaction (swelling in the throat/airway)',
            'Collapsed trachea (common in small dogs)',
            'Something stuck in the throat (bone, toy, etc.)',
            'Flat-faced breeds (pugs, bulldogs, etc.) → Some snorting is "normal," but sudden worsening is dangerous'
          ],
          actions: [
            'If mild and pet otherwise acts normal → Likely an infection or breed-related noise; mention it to your vet',
            'If noise suddenly worsens, especially with exercise or warm weather → Vet ASAP',
            'If struggling to breathe, gums turning blue, or pet collapses → Emergency vet immediately',
            'If choking on an object → Only try removing it if safe, otherwise rush to a vet'
          ],
          imagePath: 'assets/images/symptoms/wheezing.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Sneezing & Nasal Discharge',
          description:
              'An occasional sneeze is normal, but constant sneezing or unusual nose discharge needs attention.',
          causes: [
            'Allergies – Dust, pollen, smoke, perfumes, or cleaning sprays',
            'Respiratory infection',
            'Foreign object in the nose – Grass, seeds, or dirt',
            'Dental disease – Infections in the upper teeth can spread to the nose'
          ],
          actions: [
            'A few sneezes, no discharge → Likely dust or irritation, nothing to worry about',
            'Clear watery discharge that keeps happening → Could be allergies; try removing smoke, perfume, or sprays',
            'Thick yellow/green discharge → Likely infection → Vet check needed',
            'Sneezing fits + pawing at nose → Something stuck → Vet ASAP'
          ],
          imagePath: 'assets/images/symptoms/sneezing.jpg',
          emergencyLevel: 'normal',
        ),
        const PetSymptom(
          name: 'Open-Mouth Breathing in Cats',
          description:
              'Mouth breathing in cats can happen from stress or heat, but it can also mean breathing trouble.',
          causes: [
            'Heat or stress (after play, travel, or car rides)',
            'Heart or lung problems',
            'Asthma or airway issues',
            'Fluid buildup in the chest'
          ],
          actions: [
            'If it happens after play, heat, or travel → Let your cat rest in a cool, quiet spot and monitor',
            'If it continues while resting, or your cat seems tired, drools, or breathes with effort → Vet check as soon as possible',
            'If mouth breathing starts suddenly and doesn\'t stop → Emergency vet visit'
          ],
          imagePath: 'assets/images/symptoms/mouth_breathing.jpg',
          emergencyLevel: 'urgent',
        ),
        const PetSymptom(
          name: 'Gasping for Air / Struggling to Breathe',
          description:
              'If your pet can\'t breathe properly, it\'s an emergency. Don\'t wait!',
          causes: [
            'Severe allergic reaction (swollen throat!)',
            'Choking on food or a foreign object',
            'Collapsed lung or fluid in the chest',
            'Heart diseases'
          ],
          actions: [
            'Check their gums or tongue → if they look blue or pale → Emergency vet immediately!',
            'If your pet is drooling, breathing heavily, or clearly struggling to get air → RUSH to the vet!'
          ],
          imagePath: 'assets/images/symptoms/gasping.jpg',
          emergencyLevel: 'emergency',
        ),
        const PetSymptom(
          name: 'Choking',
          description:
              'If your pet suddenly starts gagging, coughing, or pawing at their mouth, something might be stuck.',
          causes: [
            'Food or treats swallowed too fast',
            'Toys, bones, or foreign objects',
            'Hair or string stuck in the throat'
          ],
          actions: [
            'If your pet is coughing or gagging but still breathing → Stay calm and observe — many pets clear it on their own',
            'If your pet can\'t breathe or collapses → Emergency! Go to the vet immediately'
          ],
          imagePath: 'assets/images/symptoms/choking.jpg',
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
