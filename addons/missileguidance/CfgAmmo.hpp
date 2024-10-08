class CfgAmmo {
    class MissileBase;

    class M_PG_AT: MissileBase {};

    class ACE_Hydra70_DAGR: M_PG_AT {
        displayName = CSTRING(Hydra70_DAGR);
        displayNameShort = CSTRING(Hydra70_DAGR_Short);

        description = CSTRING(Hydra70_DAGR_Desc);
        descriptionShort = CSTRING(Hydra70_DAGR_Desc);

        irLock = 0;
        laserLock = 0;
        manualControl = 0;
        maxSpeed = 300;

        EGVAR(rearm,caliber) = 70;

        class ADDON {
            enabled = 1;

            pitchRate = 40; // degrees per second
            yawRate = 40;

            canVanillaLock = 0;          // Can this default vanilla lock? Only applicable to non-cadet mode

            // Guidance type for munitions
            defaultSeekerType = "SALH";
            seekerTypes[] = { "SALH" };

            defaultSeekerLockMode = "LOAL";
            seekerLockModes[] = { "LOAL", "LOBL" };

            defaultNavigationType = "AugmentedProportionalNavigation";
            navigationTypes[] = { "AugmentedProportionalNavigation" };

            seekerAngle = 90;           // Angle in front of the missile which can be searched
            seekerAccuracy = 1;         // seeker accuracy multiplier

            seekerMinRange = 1;
            seekerMaxRange = 2500;      // Range from the missile which the seeker can visually search

            // Attack profile type selection
            defaultAttackProfile = "LIN";
            attackProfiles[] = { "LIN", "DIR", "MID", "HI" };
        };
    };

    // Titan
    class M_Titan_AT: MissileBase {};

    class ACE_Javelin_FGM148: M_Titan_AT {
        irLock = 1;
        laserLock = 0;
        airLock = 0;

        // Turn off arma crosshair-guidance
        manualControl = 0;

        hit = 1400;         // default: 800
        indirectHit = 20;
        indirectHitRange = 2;
        // ACE uses these values
        //trackOversteer = 1;
        //trackLead = 0;

        initTime = 0.5;

        // Begin ACE guidance Configs
        class ADDON {
            enabled = 1;

            pitchRate = 100; // degrees per second
            yawRate = 100;
            stabilityCoefficient = 0.2;
            bangBangGuidance = 0;

            canVanillaLock = 0;

            // Guidance type for munitions
            defaultSeekerType = "Optic";
            seekerTypes[] = { "Optic" };

            defaultSeekerLockMode = "LOBL";
            seekerLockModes[] = { "LOBL" };

            defaultNavigationType = "Direct";
            navigationTypes[] = { "Direct", "ZeroEffortMiss" };

            navigationGain = 3;

            seekerAngle = 180;           // Angle in front of the missile which can be searched
            seekerAccuracy = 1;         // seeker accuracy multiplier

            seekerMinRange = 0;
            seekerMaxRange = 2500;      // Range from the missile which the seeker can visually search

            seekLastTargetPos = 1;      // seek last target position [if seeker loses LOS of target, continue to last known pos]

            // Attack profile type selection
            defaultAttackProfile = "JAV_TOP";
            attackProfiles[] = { "JAV_TOP", "JAV_DIR" };
            useModeForAttackProfile = 1;

            class navigationStates {
                class initial {
                    transitionCondition = QFUNC(javelin_midCourseTransition);
                    navigationType = "Direct";
                };
                class terminal {
                    transitionCondition = "";
                    navigationType = "ZeroEffortMiss";
                };
                // transitions from initial -> termimal
                states[] = {"initial", "terminal"};
            };
        };
    };
    class ACE_Javelin_FGM148_static: ACE_Javelin_FGM148 {
        //Take config changes from (M_Titan_AT_static: M_Titan_AT)
        initTime = 0.25;  //"How long (in seconds) the projectile waits before starting it's engine.", - but doesn't seem to do anything
        effectsMissileInit = "RocketBackEffectsStaticRPG";

        //Explicity add guidance config
        class ADDON: ADDON {};
    };
};
