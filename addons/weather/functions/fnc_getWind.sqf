/*
 * Author: ACE2 Team
 *
 * Calculate current wind locally from the data broadcasted by the server
 *
 * Argument:
 * None
 *
 * Return value:
 * Wind <ARRAY>
 */
#include "script_component.hpp"

// Source: https://weatherspark.com/averages/32194/Lemnos-Limnos-North-Aegean-Islands-Greece
_AB_Wind_Speed_Max = [[8.8, 5.5], [8.8, 5], [8.6, 4.8], [7.6, 3.4], [7.0, 3.0], [7.1, 3.0], [7.5, 3.1], [8.0, 3.2], [7.6, 3.5], [7.8, 4.6], [7.9, 5.0], [8.2, 5.5]];
_AB_Wind_Speed_Mean = [4.8, 4.9, 4.6, 4.1, 3.5, 3.5, 4.3, 4.4, 4.1, 4.5, 4.5, 5.0];
_AB_Wind_Speed_Min = [[0.2, 5.0], [0.1, 5.0], [0.2, 4.3], [0.0, 3.0], [0.0, 2.1], [0.0, 2.0], [0.1, 3.1], [0.3, 3.1], [0.0, 3.6], [0.0, 4.2], [0.1, 5.0], [0.2, 5.5]];
_AB_Wind_Direction_Probabilities = [[0.06, 0.32, 0.05, 0.04, 0.15, 0.06, 0.02, 0.02], // January
                                        [0.08, 0.32, 0.04, 0.04, 0.18, 0.06, 0.02, 0.02], // February
                                        [0.09, 0.30, 0.04, 0.04, 0.20, 0.06, 0.02, 0.03], // March
                                        [0.10, 0.25, 0.03, 0.04, 0.22, 0.06, 0.02, 0.04], // April
                                        [0.18, 0.25, 0.03, 0.04, 0.18, 0.04, 0.01, 0.05], // May
                                        [0.25, 0.25, 0.03, 0.03, 0.15, 0.03, 0.00, 0.08], // June
                                        [0.32, 0.30, 0.02, 0.02, 0.10, 0.01, 0.00, 0.09], // July
                                        [0.28, 0.35, 0.02, 0.01, 0.08, 0.01, 0.00, 0.08], // August
                                        [0.20, 0.37, 0.03, 0.01, 0.11, 0.01, 0.01, 0.05], // September
                                        [0.10, 0.39, 0.04, 0.02, 0.15, 0.02, 0.01, 0.03], // October
                                        [0.08, 0.38, 0.06, 0.04, 0.19, 0.03, 0.02, 0.02], // November
                                        [0.06, 0.37, 0.05, 0.03, 0.18, 0.04, 0.02, 0.02]];// December
                                    
_PI = 3.14159265;
_c1 = 0.2 + random 0.2;
_c2 = 0.3 + random 0.2;
_c3 = 0.5 + random 0.2;
_c4 = 0.7 + random 0.2;

_month = date select 1;
_windDirectionProbabilities = _AB_Wind_Direction_Probabilities select (_month - 1);
while {isNil QGVAR(windDirectionReference)} do {
    _random = random 1;
    for "_i" from 0 to 7 do {
        if (_random < (_windDirectionProbabilities select _i)) exitWith {
            GVAR(windDirectionReference) = 45 * _i;
        };
    };
    GVAR(windDirectionReference) = GVAR(windDirectionReference) + (random 22.5) - (random 22.5);
    GVAR(windDirectionVariance) = (random 10) - (random 10);
};

if (isNil QGVAR(minWindSpeed) || isNil QGVAR(maxWindSpeed)) then {
    GVAR(minWindSpeed) = _AB_Wind_Speed_Min select (_month - 1);
    GVAR(minWindSpeed) = (GVAR(minWindSpeed) select 0) + (random (GVAR(minWindSpeed) select 1)) - (random (GVAR(minWindSpeed) select 1));
    GVAR(minWindSpeed) = 0 max GVAR(minWindSpeed);
    GVAR(maxWindSpeed) = _AB_Wind_Speed_Max select (_month - 1);
    GVAR(maxWindSpeed) = (GVAR(maxWindSpeed) select 0) + (random (GVAR(maxWindSpeed) select 1)) - (random (GVAR(maxWindSpeed) select 1));
    GVAR(maxWindSpeed) = 0 max GVAR(maxWindSpeed);
};

if ((random 30) < 1) then {
    GVAR(windDirectionVariance) = (random 10) - (random 10);
};
_windDirection = GVAR(windDirectionReference) + GVAR(windDirectionVariance);

_x = time * 180 / _PI;
_ratio = 0 max ((1 + _c1 * sin(_x/1.5) + _c2 * sin(_x/3) + _c3 * sin(_x/12) + _c4 * sin(_x/18)) / (1 + _c1 + _c2 + _c3 + _c4));
_windSpeed = GVAR(minWindSpeed) + (GVAR(maxWindSpeed) - GVAR(minWindSpeed)) * _ratio;

systemChat " ";
systemChat format["(Min/Current/Max) : (%1/%2/%3)", Round(GVAR(minWindSpeed) * 10) / 10, Round(_windSpeed * 10) / 10, Round(GVAR(maxWindSpeed) * 10) / 10];
systemChat format["(Reference/Current/Variance):(%1/%2/%3)", Round(GVAR(windDirectionReference)), Round(_windDirection), Round(GVAR(windDirectionVariance))];
systemChat " ";
systemChat " ";

[-1 * sin(_windDirection) * _windSpeed, -1 * cos(_windDirection) * _windSpeed, 0]
