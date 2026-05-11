% --- 1. אתחול וקריאת נתונים ---
[y, Fs] = audioread('audiodata.wav');
if size(y, 2) > 1 %אם זהו קובץ סטריאו, נמנע כפילות
    y = y(:, 1); 
end

% הגדרות חלון זמן
T_halon = 0.025; 
N_halon = round(T_halon * Fs); %כמה דגימות
num_halonot = floor(length(y) / N_halon);

% הגדרות תדרים ומקשים
f_namuch = [697, 770, 852, 941];
f_gavoha = [1209, 1336, 1477, 1633];
makashim = ['1','2','3','A'; '4','5','6','B'; '7','8','9','C'; '*','0','#','D'];

% משתני עזר לפיענוח
mispar_sofi = '';
retzef = 0;
last_makash = '';
saf_energia = 0.2 * max(y.^2) * N_halon; %הגזרת אחוז מתוך הדר הגבוה ביותר כסף מינימום

% --- 2. לולאה שעוברת על כל החלונות ---
for i = 1:num_halonot
    
    start_idx = (i-1) * N_halon + 1;
    end_idx = i * N_halon;
    halon = y(start_idx:end_idx);
    
    energia = sum(halon .^ 2); %חישוב אנרגיה לחלון כדי שנבדיל בין רעש ללחיצה
    
    if energia > saf_energia 
        
        Y = abs(fft(halon)); %מעבר למישור התדר וחישוב הערך המוחלט כדי למנוע מספר שלילי
        tzir_f = (0:N_halon-1) * (Fs/N_halon); 
        
        hetzi = floor(N_halon/2); %נחתוך חצי מההתמרה כי יש סימטריה, ואין בזה מידע חדש
        Y = Y(1:hetzi);
        tzir_f = tzir_f(1:hetzi);
        
        tvach_namuch = find(tzir_f >= 650 & tzir_f <= 1000); %מציאת לחיצה בתדרי העמודות
        [~, max_l_idx] = max(Y(tvach_namuch));
        peak_n = tzir_f(tvach_namuch(max_l_idx));
        
        tvach_gavoha = find(tzir_f >= 1100 & tzir_f <= 1700); %מציאת לחיצה בתדרי השורות
        [~, max_h_idx] = max(Y(tvach_gavoha));
        peak_g = tzir_f(tvach_gavoha(max_h_idx));
        %שיוך התדרים שמצאנו לתדר הקרוב(יוצאים מנקודת הנחה שהתדר המתקבל הוא
        %לא בדיוק בתדרי הDTMF
        [~, shura] = min(abs(f_namuch - peak_n));
        [~, amuda] = min(abs(f_gavoha - peak_g));
        makash_nochechi = makashim(shura, amuda);
       
        % --- 3. מניעת כפילויות ---
        if makash_nochechi == last_makash
            retzef = retzef + 1;
            if retzef == 3 %נדרוש 3 חלונות ברצף כדי לוודא שזה לא רעש אלא לחיצה אמיתית
                mispar_sofi = [mispar_sofi, makash_nochechi];
            end
        else
            last_makash = makash_nochechi;
            retzef = 1;
        end
        
    else
        last_makash = '';% במקרה שהאנרגיה נמוכה מהסף נאפס אותה
        retzef = 0;
    end
end
disp(['המספר שזוהה: ', mispar_sofi]);
