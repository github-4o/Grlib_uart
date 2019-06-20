library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg4o.all;


entity uart_printer is
    generic (
        gReset_active_lvl: std_logic := '0'
    );
    port (
        iClk: in std_logic;
        iReset: in std_logic;

        iRs: in std_logic
    );
end entity;

architecture v1 of uart_printer is

    constant cLF: std_logic_vector (7 downto 0) := x"0a";

    component grlib_uart_wrap
        port (
            iClk: in std_logic; -- clock signal
            iReset: in std_logic; -- async reset signal

            iRs: in std_logic; -- phy input
            oRs: out std_logic; -- phy output

            -- write iface:
            iNd: in std_logic; -- new data for iData port
            iData: in std_logic_vector (7 downto 0); -- valid when iNd = '1'
            oEmpty: out std_logic;

            -- read iface: reads data when it arrives to controller
            oNd: out std_logic; -- new data for oData port
            oData: out std_logic_vector (7 downto 0) -- valid when oNd = '1'
        );
    end component;

    signal sNd: std_logic;
    signal sData: std_logic_vector (7 downto 0);

begin

    uart: grlib_uart_wrap
        port map (
            iClk => iClk,
            iReset => iReset,

            iRs => iRs,
            --oRs: out std_logic; -- phy output

            -- write iface:
            iNd => '0',
            iData => x"00",
            --oEmpty: out std_logic;

            -- read iface: reads data when it arrives to controller
            oNd => sNd,
            oData => sData
        );

    process (iClk, iReset)
        variable s: string (1 to 60);
        variable index: integer := 1;

        procedure print is
        begin
            print (s(1 to index));
            index := 1;
        end procedure;

        procedure add_char (
            slv: std_logic_vector (7 downto 0)
        ) is
        begin
            if slv = cLF then
                print;
            else
                s(index) := character'val (to_integer(unsigned(sData)));
                index := index +1;
                if index > s'length then
                    print;
                end if;
            end if;
        end procedure;
    begin
        if iReset = gReset_active_lvl then
        else
            if iClk'event and iClk = '1' then
                if sNd = '1' then
                    add_char (sData);
                    --print ("adding " & printh (sData) & "string: " & s);
                end if;
            end if;
        end if;
    end process;

end v1;
