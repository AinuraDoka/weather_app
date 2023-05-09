class WeatherData {
  String calculateWeather(double kelvin) {
    final data = (kelvin - 273.15).toStringAsFixed(0);
    return data;
  }

  String? getDescription(num temp) {
    if (temp > 25) {
      return 'Bugun ysyk';
    } else if (temp > 20) {
      return 'Salkyn bolot';
    } else if (temp < 10) {
      return 'Suuk bolot';
    } else {
      'Jyluu kiyinip al';
    }
  }

  String? getWeatherIcon(num temp) {
    if (temp > 20 - 25) {
      return '🌞';
    } else if (temp > 10 - 20) {
      return '⛅';
    } else if (temp < 0 - 10) {
      return '🌦';
    } else if (temp < 0 - 10) {
      return '❆';
    } else {
      '🌝';
    }
  }
}

final WeatherData weatherData = WeatherData();
