library ieee;
use ieee.std_logic_1164.all;


entity grlib_uart_wrap is
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
end entity;

architecture v1 of grlib_uart_wrap is

    component grlib_uart
        port (
            rst    : in  std_ulogic;
            clk    : in  std_ulogic;

            read: in std_logic;
            dready: out std_logic;
            odata: out std_logic_vector (7 downto 0);

            write: in std_logic;
            idata: in std_logic_vector (7 downto 0);

            --tsempty: out std_logic;
            thempty: out std_logic;
            lock: out std_logic;
            enable: out std_logic;

            iRs: in std_logic;
            oRs: out std_logic
        );
    end component;

    component grlib_uart_wrap_fsm
        port (
            iClk: in std_logic;
            iReset: in std_logic;

            iNd: in std_logic;
            iData: in std_logic_vector (7 downto 0);

            oNd: out std_logic;
            oData: out std_logic_vector (7 downto 0);

            read: out std_logic;
            dready: in std_logic;
            datao: in std_logic_vector (7 downto 0);

            write: out std_logic;
            datai: out std_logic_vector (7 downto 0)
        );
    end component;

    signal read: std_logic;
    signal dready: std_logic;
    signal datao: std_logic_vector (7 downto 0);
    signal write: std_logic;
    signal datai: std_logic_vector (7 downto 0);

begin

    uart: grlib_uart
        port map (
            rst => iReset,
            clk => iClk,

            read => read,
            dready => dready,
            odata => datao,

            write => write,
            idata => datai,

            --tsempty: out std_logic;
            thempty => oEmpty,
            --lock: out std_logic;
            --enable: out std_logic;

            iRs => iRs,
            oRs => oRs
        );

    fsm: grlib_uart_wrap_fsm
        port map (
            iClk => iClk,
            iReset => iReset,

            iNd => iNd,
            iData => iData,

            oNd => oNd,
            oData => oData,

            read => read,
            dready => dready,
            datao => datao,

            write => write,
            datai => datai
        );

end v1;
