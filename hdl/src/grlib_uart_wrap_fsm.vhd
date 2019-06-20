library ieee;
use ieee.std_logic_1164.all;


entity grlib_uart_wrap_fsm is
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
end entity;

architecture v1 of grlib_uart_wrap_fsm is

begin

    read <= dready;
    oNd <= dready;
    oData <= datao;

    write <= iNd;
    datai <= iData;

end v1;
