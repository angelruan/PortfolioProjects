import pandas as pd 
from countries_codes import get_country_code
import pygal.maps.world
from pygal.style import LightColorizedStyle, RotateStyle

# Parse json file 
url = 'https://raw.githubusercontent.com/ehmatthes/pcc/master/chapter_16/population_data.json'
df = pd.read_json(path_or_buf=url)

# Filter the data by year = 2010
df2 = df[df['Year']==2010].copy()

# change the float data type to int data type 
df2['Value'] = df2['Value'].astype(dtype='int')

# Build a list of all countries name 
country_list = list(df2['Country Name'])

# Build a dictionary of population data.
cc_population = {}
for country_name in country_list:
    code = get_country_code(country_name)
    if code:
        cc_population[code] = int(df2.loc[df2["Country Name"] == country_name]["Value"].to_string(index=False))

# Group the countries into 3 population levels
cc_pops_1, cc_pops_2, cc_pops_3 = {}, {}, {}
for cc, pop in cc_population.items():
    if pop < 10000000:
        cc_pops_1[cc] = pop
    elif pop < 1000000000:
        cc_pops_2[cc] = pop
    else:
        cc_pops_3[cc] = pop

print(len(cc_pops_1), len(cc_pops_2), len(cc_pops_3))
wm_style = RotateStyle('#336699', base_style=LightColorizedStyle)
wm = pygal.maps.world.World(style=wm_style)
wm.title = 'World Population in 2010, by Country'
wm.add('0-10m', cc_pops_1)
wm.add('10m-1bn', cc_pops_2)
wm.add('>1bn', cc_pops_3)

wm.render_to_file('world_population.svg')
# print(df2['Info'])
