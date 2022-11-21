-- Simple DDS tone generator.
-- 5-bit tuning word
-- 9-bit phase register
-- 256 x 8-bit ROM.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

LIBRARY ALTERA_MF;
USE ALTERA_MF.ALTERA_MF_COMPONENTS.ALL;

LIBRARY LPM;
USE LPM.LPM_COMPONENTS.ALL;


ENTITY TONE_GEN IS 
	PORT
	(
		CMD        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		CS         : IN  STD_LOGIC;
		SAMPLE_CLK : IN  STD_LOGIC;
		RESETN     : IN  STD_LOGIC;
		L_DATA     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		R_DATA     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END TONE_GEN;

ARCHITECTURE gen OF TONE_GEN IS 

	-- internal signals
	SIGNAL phase_register : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL tuning_word    : STD_LOGIC_VECTOR(13 DOWNTO 0);
	SIGNAL tw_shifted     : STD_LOGIC_VECTOR(13 DOWNTO 0);
	SIGNAL shift_amnt     : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL sounddata      : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL sounddata1      : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL soundOutRight	 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL soundOutLeft	 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	-- signal from SCOMP
	SIGNAL note           : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL sharp          : STD_LOGIC;
	SIGNAL octave         : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL left_vol       : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL right_vol      : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL use_square     : STD_LOGIC;
	-- base note values
	SIGNAL C2             : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL C2S            : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL D2             : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL D2S            : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL E2             : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL F2             : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL F2S            : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL G2             : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL G2S            : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL A2             : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL A2S            : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL B2             : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
BEGIN


	-- ROM to hold the waveform
	SOUND_LUT : altsyncram
	GENERIC MAP (
		lpm_type => "altsyncram",
		width_a => 8,
		widthad_a => 8,
		numwords_a => 256,
		init_file => "SOUND_SINE.mif",
		intended_device_family => "Cyclone II",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		power_up_uninitialized => "FALSE"
	)
	PORT MAP (
		clock0 => NOT(SAMPLE_CLK),
		address_a => phase_register(15 downto 8),
		q_a => sounddata -- output is amplitude
	);
	
	
	-- ROM to hold the SQUARE waveform
	SQUARE_LUT : altsyncram
	GENERIC MAP (
		lpm_type => "altsyncram",
		width_a => 8,
		widthad_a => 8,
		numwords_a => 256,
		init_file => "SOUND_SQUARE.mif",
		intended_device_family => "Cyclone II",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		power_up_uninitialized => "FALSE"
	)
	PORT MAP (
		clock0 => NOT(SAMPLE_CLK),
		-- In this design, one bit of the phase register is a fractional bit
		address_a => phase_register(15 downto 8),
		q_a => sounddata1 -- output is amplitude
	);


	
	-- shifter for tuning word to increase octave
	shifter: lpm_clshift
	generic map (
		 lpm_width     => 14,
		 lpm_widthdist => 3,
		 lpm_shifttype => "arithmetic"
	)
	port map (
		 data      => tuning_word,
		 distance  => shift_amnt,
		 direction => '0',
		 result    => tw_shifted
	);
	
	
	-- assign outputs
	L_DATA <= soundOutLeft;
	R_DATA <= soundOutRight;
	
	
	-- tuning word for each note in octave 2
	C2 <= "01011001";
	C2S <= "01011111";
	D2 <= "01100100";
	D2S <= "01101010";
	E2 <= "01110001";
	F2 <= "01110111";
	F2S <= "01111110";
	G2 <= "10000110";
	G2S <= "10001110";
	A2 <= "10010110";
	A2S <= "10011111";
	B2 <= "10101001";
	
	
	-- process to update phase register
	PROCESS(RESETN, SAMPLE_CLK) BEGIN
		IF RESETN = '0' THEN
			phase_register <= "0000000000000000";
		ELSIF RISING_EDGE(SAMPLE_CLK) THEN
			IF tuning_word = "00000000000000" THEN
				phase_register <= "0000000000000000";
			ELSE
				phase_register <= phase_register + ("00" & tw_shifted);
			END IF;
		END IF;
	END PROCESS;
			
			
	-- process to get input signal and find tuning word
	PROCESS(RESETN, CS) BEGIN

		IF RESETN = '0' THEN
			 
			 -- reset to defaults
			note <= "0000000";
			sharp <= '0';
			octave <= "000";
			left_vol <= "00";
			right_vol <= "00";
			use_square <= '0';

		ELSIF RISING_EDGE(CS) THEN
		
			-- parse input signal
			note <= CMD(15 DOWNTO 9);
			sharp <= CMD(8);
			octave <= CMD(7 DOWNTO 5);
			left_vol <= CMD(4 DOWNTO 3);
			right_vol <= CMD(2 DOWNTO 1);
			use_square <= CMD(0);
			
			-- set base tuning word according to note/sharp
			IF note = "1000000" THEN -- c note
				IF sharp = '1' THEN
					tuning_word <= "000000" & C2S;
				ELSE 
					tuning_word <= "000000" & C2;
				END IF;
			ELSIF note = "0100000" THEN -- d note
				IF sharp = '1' THEN
					tuning_word <= "000000" & D2S;
				ELSE 
					tuning_word <= "000000" & D2;
				END IF;
			ELSIF note = "0010000" THEN -- e note
				tuning_word <= "000000" & E2;
			ELSIF note = "0001000" THEN -- f note
				IF sharp = '1' THEN
					tuning_word <= "000000" & F2S;
				ELSE 
					tuning_word <= "000000" & F2;
				END IF;
			ELSIF note = "0000100" THEN -- g note
				IF sharp = '1' THEN
					tuning_word <= "000000" & G2S;
				ELSE 
					tuning_word <= "000000" & G2;
				END IF;
			ELSIF note = "0000010" THEN -- a note
				IF sharp = '1' THEN
					tuning_word <= "000000" & A2S;
				ELSE 
					tuning_word <= "000000" & A2;
				END IF;
			ELSIF note = "0000001" THEN -- b note
				tuning_word <= "000000" & B2;
			ELSE -- "000" = off			
				tuning_word <= "00000000000000";
			END IF;
			
			-- adjust shift amount based on octave
			IF octave = "000" THEN
				shift_amnt <= "000";
				tuning_word <= "00000000000000";
			ELSE
				shift_amnt <= octave - "001";
			END IF;

		END IF;
	END PROCESS;
	
	-- process to set left volume level
	PROCESS(left_vol, use_square, sounddata, sounddata1) BEGIN
		IF left_vol = "00" THEN
			soundOutLeft <= "0000000000000000";
		ELSIF left_vol = "01" THEN
			if use_square = '0' then
				soundOutLeft <= "0000" & sounddata & "0000";
			else
				soundOutLeft <= "0000" & sounddata1 & "0000";
			end if;
		ELSIF left_vol = "10" THEN
			if use_square = '0' then
				soundOutLeft <= sounddata(7)&sounddata(7)&"000000"&sounddata;
			else
				soundOutLeft <= sounddata1(7)&sounddata1(7)&"000000"&sounddata1;
			end if;
		ELSIF left_vol = "11" THEN
			if use_square = '0' then
				soundOutLeft <= sounddata(7)& "000000" & sounddata & "0";
			else
				soundOutLeft <= sounddata1(7)& "000000" & sounddata1 & "0";
			end if;
		END IF;
	END PROCESS;
	
	-- process to set right volume level
	PROCESS(right_vol, use_square, sounddata, sounddata1) BEGIN
		IF right_vol = "00" THEN
			soundOutRight <= "0000000000000000";
		ELSIF right_vol = "01" THEN
			if use_square = '0' then
				soundOutRight <= "0000" & sounddata & "0000";
			else
				soundOutRight <= "0000" & sounddata1 & "0000";
			end if;
		ELSIF right_vol = "10" THEN
			if use_square = '0' then
				soundOutRight <= sounddata(7)&sounddata(7)&"000000"&sounddata;
			else
				soundOutRight <= sounddata1(7)&sounddata1(7)&"000000"&sounddata1;
			end if;
		ELSIF right_vol = "11" THEN
			if use_square = '0' then
				soundOutRight <= sounddata(7)& "000000" & sounddata & "0";
			else
				soundOutRight <= sounddata1(7)& "000000" & sounddata1 & "0";
			end if;
		END IF;
	END PROCESS;
	
	
END gen;