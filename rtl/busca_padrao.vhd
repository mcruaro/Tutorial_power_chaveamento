-------------------------------------------------------------------------------------------------
-- FERNANDO MORAES    -  ago/2013                                                                 
--
-- periférico para buscar padrão em imagem
--
-------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity busca_padrao is

  port
  (
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Reset                   : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(7 downto 0);
    Bus2IP_RdCE                    : in  std_logic_vector(0 to 14);
    Bus2IP_WrCE                    : in  std_logic_vector(0 to 14);
    IP2Bus_Data                    : out std_logic_vector(7 downto 0);
    user_int                       : out std_logic
  );

end entity busca_padrao;


architecture a1 of busca_padrao is

  type bank is array(0 to 14) of std_logic_vector(7 downto 0);   
  signal slv_reg : bank ;                            
     
  signal reseta_bit_slv_reg0            : std_logic;
  
  type STATES is (REP, PI1, PI2, PI3, PI4, PI5, PI6, PI7, PI8, PI9, NEXT_PIXEL, FIM, MATCH);
  signal EA : STATES;    
            
  signal endx, endy : std_logic_vector(3 downto 0);
  signal address, pixel : std_logic_vector(7 downto 0);

  --
  --  imagem declarada como um ROM
  --
  type iram is array (0 to 255) of std_logic_vector(7 downto 0);
  constant imagem : iram := (
      x"40", x"00", x"24", x"9C", x"24", x"9D", x"24", x"9E", x"44", x"9D", x"24", x"FF", x"44", x"9E", x"24", x"FE",
      x"44", x"9C", x"24", x"A0", x"CC", x"4D", x"44", x"A0", x"24", x"CC", x"72", x"9C", x"BC", x"21", x"CC", x"02",
      x"24", x"9F", x"44", x"9F", x"50", x"FF", x"24", x"9F", x"BC", x"8C", x"E6", x"40", x"32", x"10", x"40", x"C6",
      x"8C", x"F8", x"00", x"00", x"00", x"00", x"8C", x"E8", x"D0", x"50", x"FF", x"BC", x"04", x"00", x"00", x"40",
      x"1C", x"44", x"A0", x"24", x"9D", x"50", x"A7", x"BC", x"02", x"00", x"24", x"9C", x"44", x"9D", x"24", x"A0",
      x"8C", x"CB", x"40", x"00", x"24", x"9C", x"24", x"9D", x"CC", x"44", x"9E", x"24", x"A0", x"CC", x"06", x"44",
      x"24", x"9E", x"8C", x"B9", x"44", x"A0", x"50", x"01", x"24", x"A0", x"70", x"0F", x"50", x"F6", x"BC", x"01",
      x"D0", x"44", x"A0", x"70", x"F0", x"50", x"10", x"24", x"A0", x"50", x"60", x"BC", x"01", x"D0", x"40", x"00",
      x"24", x"A0", x"D0", x"44", x"9C", x"70", x"0F", x"BC", x"01", x"D0", x"44", x"A1", x"54", x"A1", x"24", x"A1",
      x"BC", x"03", x"24", x"FD", x"D0", x"40", x"01", x"24", x"A1", x"8C", x"F7", x"00", x"00", x"00", x"00", x"00",
      x"00", x"9C", x"A0", x"44", x"9D", x"24", x"A0", x"CC", x"1C", x"44", x"9F", x"44", x"9F", x"50", x"A7", x"BC",
      x"02", x"8C", x"CB", x"40", x"00", x"24", x"9C", x"00", x"24", x"9C", x"F8", x"00", x"00", x"9E", x"44", x"9D",
      x"24", x"FF", x"44", x"9E", x"24", x"FE", x"CC", x"72", x"44", x"9C", x"44", x"A0", x"24", x"4D", x"44", x"A0",
      x"24", x"9C", x"24", x"9C", x"44", x"9D", x"24", x"A0", x"8C", x"F8", x"00", x"00", x"00", x"50", x"60", x"BC",
      x"24", x"9F", x"BC", x"8C", x"40", x"00", x"24", x"9C", x"40", x"00", x"24", x"9C", x"9F", x"BC", x"8C", x"E6",
      x"9D", x"50", x"A7", x"BC", x"02", x"00", x"24", x"9C", x"00", x"9C", x"A0", x"44", x"9F", x"50", x"FF", x"24");
begin

  --
  -- lê a memória com a imagem
  --
  pixel <=  imagem(CONV_INTEGER(address)) ;            -- memory reading

   --
   --  escrita por parte de uma CPU externa e do hw do usuário nos registradores 
   --
   process(Bus2IP_Reset, Bus2IP_Clk)
     begin
   
        if Bus2IP_Reset = '1' then
             slv_reg(0) <= (others => '0');
             slv_reg(1) <= (others => '0');
             slv_reg(2) <= (others => '0');
             slv_reg(3) <= (others => '0');
             slv_reg(4) <= (others => '0');
             slv_reg(5) <= (others => '0');
             slv_reg(6) <= (others => '0');
             slv_reg(7) <= (others => '0');
             slv_reg(8) <= (others => '0');
             slv_reg(9) <= (others => '0');
             slv_reg(10) <= (others => '0');
             slv_reg(11) <= (others => '0');
             slv_reg(12) <= (others => '0');
             slv_reg(13) <= (others => '0');
             slv_reg(14) <= (others => '0');

       elsif Bus2IP_Clk'event and Bus2IP_Clk = '1' then
              
         if EA=MATCH then                  -- escrita nos registradores de match
                 
                 slv_reg(10) <= slv_reg(11) + 1;
                 
                 if slv_reg(10)=0 then                       --- primeiro match
                     slv_reg(11) <=  "0000" & endx;
                     slv_reg(12) <=  "0000" & endy;
                 elsif slv_reg(10)=1 then                    --- segundo match
                     slv_reg(13) <=  "0000" & endx;
                     slv_reg(14) <=  "0000" & endy;
                 end if;
         elsif reseta_bit_slv_reg0='1' then    -- se estava ativo o bit(0) do reg9 desativá-lo - start operation!
             slv_reg(9) <= (others => '0');              
         else                                  
                case Bus2IP_WrCE is
                  when "100000000000000" => slv_reg(0) <= Bus2IP_Data;
                  when "010000000000000" => slv_reg(1) <= Bus2IP_Data;
                  when "001000000000000" => slv_reg(2) <= Bus2IP_Data;
                  when "000100000000000" => slv_reg(3) <= Bus2IP_Data;
                  when "000010000000000" => slv_reg(4) <= Bus2IP_Data;
                  when "000001000000000" => slv_reg(5) <= Bus2IP_Data;
                  when "000000100000000" => slv_reg(6) <= Bus2IP_Data;
                  when "000000010000000" => slv_reg(7) <= Bus2IP_Data;
                  when "000000001000000" => slv_reg(8) <= Bus2IP_Data;
                  when "000000000100000" => slv_reg(9) <= Bus2IP_Data;    -- start operation
                  when others => null;
                end case;        
         end if;
         

       end if;
     end process;
     
      
   --
   --  leitura por parte de uma CPU 
   --
   SLAVE_REG_READ_PROC : process( Bus2IP_RdCE, slv_reg ) is
   begin

    case Bus2IP_RdCE is
      when "000000000010000" => IP2Bus_Data <= slv_reg(10);   -- número de matches
      when "000000000001000" => IP2Bus_Data <= slv_reg(11);   -- primeiro par (x,y) 
      when "000000000000100" => IP2Bus_Data <= slv_reg(12);
      when "000000000000010" => IP2Bus_Data <= slv_reg(13);
      when "000000000000001" => IP2Bus_Data <= slv_reg(14);   -- segundo par (x,y) 
      when others => IP2Bus_Data <= (others=>'0');
    end case;

  end process SLAVE_REG_READ_PROC;
  
  
  --- algoritmo propriamente dito
   

   --   máquina de estados responsável por controlar o periférico (BLOCO DE CONTROLE)
   process(Bus2IP_Clk, Bus2IP_Reset)
    begin       
       if Bus2IP_Reset = '1' then
             EA <= REP;
             reseta_bit_slv_reg0 <= '0';
       elsif Bus2IP_Clk'event and Bus2IP_Clk='1' then  
       
        case EA is

         when REP    => user_int<= '0';
                        if slv_reg(9)(0)='1' then EA<=PI1;  
                                             reseta_bit_slv_reg0 <= '1';
                                             else EA<=REP; 
                        end if;
              
         when PI1 =>   reseta_bit_slv_reg0 <= '0';                --- baixa o sinal de "start"
                       if pixel=slv_reg(0) then EA <= PI2;  
                                       else EA <= NEXT_PIXEL; 
                       end if;
                                                 
         when PI2 =>   if pixel=slv_reg(1) then EA <= PI3;  
                                       else EA <= NEXT_PIXEL; 
                       end if;
         
         when PI3 =>   if pixel=slv_reg(2) then EA <= PI4;  
                                       else EA <= NEXT_PIXEL; 
                       end if;
                                                 
         when PI4 =>   if pixel=slv_reg(3) then EA <= PI5;  
                                       else EA <= NEXT_PIXEL; 
                       end if;

         when PI5 =>   if pixel=slv_reg(4) then EA <= PI6;  
                                       else EA <= NEXT_PIXEL; 
                       end if;
                                                 
         when PI6 =>   if pixel=slv_reg(5) then EA <= PI7;  
                                       else EA <= NEXT_PIXEL; 
                       end if;

         when PI7 =>   if pixel=slv_reg(6) then EA <= PI8;  
                                       else EA <= NEXT_PIXEL; 
                       end if;
                                                 
         when PI8 =>   if pixel=slv_reg(7) then EA <= PI9;  
                                       else EA <= NEXT_PIXEL; 
                       end if;

         when PI9 =>   if pixel=slv_reg(8) then EA <= MATCH;  
                                       else EA <= NEXT_PIXEL; 
                       end if;
                                                   
         when NEXT_PIXEL =>  if endx=14 and endy=14 then  -- NESTE ESTADO SÓ IRÁ CONTROLAR AS COORDENADAS DA IMAGEM
                                     EA <= FIM;
                               else
                                     EA <= PI1;  
                             end if;
  
  
         when FIM  => EA <= REP;    --- volta ao início, e no início fica aguardando o  slv_reg(9)(0) (start)
                      user_int<='1'; -- *** ativa a interrupção ***
                      
 
         when MATCH => EA <= NEXT_PIXEL ;
         
       end case;
      end if;
    end process;   
        
    --  controle dos enderecos para acessar a memoria
    process(Bus2IP_Clk, Bus2IP_Reset)
    begin       
       if Bus2IP_Reset = '1' then
           endx                <=  (others=>'0');
           endy                <=  (others=>'0');
           address             <=  (others=>'0');
           
        elsif Bus2IP_Clk'event and Bus2IP_Clk='0' then  

            case EA is
               when PI1        => address <=   endy      &  endx;
               when PI2        => address <=   endy      &  (endx+1);
               when PI3        => address <=   endy      &  (endx+2);
               when PI4        => address <=   (endy +1) &  endx;
               when PI5        => address <=   (endy +1) &  (endx+1);
               when PI6        => address <=   (endy +1) &  (endx+2);
               when PI7        => address <=   (endy +2) &  endx;
               when PI8        => address <=   (endy +2) &  (endx+1);
               when PI9        => address <=   (endy +2) &  (endx+2);
               when NEXT_PIXEL => endx<= endx + 1;
                                  if endx = 15 then 
                                       endx <=  (others=>'0');
                                       endy<= endy + 1;
                                  end if;   
               when others => null;
            end case;

       end  if;
    end process; 
   
   
end a1;
