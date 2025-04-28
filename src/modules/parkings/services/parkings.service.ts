import { Injectable, NotFoundException, ForbiddenException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Parking } from '../entities/parking.entity';
import { CreateParkingDto } from '../dto/create-parking.dto';
import { UpdateParkingDto } from '../dto/update-parking.dto';
import { SearchParkingDto } from '../dto/search-parking.dto';
import { VerificationLevel } from 'src/modules/users/entities/user.entity';
import { UsersService } from 'src/modules/users/users.service';

@Injectable()
export class ParkingsService {
  constructor(
    @InjectRepository(Parking)
    private parkingsRepository: Repository<Parking>,
        private usersService: UsersService,
  ) {}

  async create(userId: string, createParkingDto: CreateParkingDto): Promise<Parking> {
    const user = await this.usersService.findOne(userId);
    
    // Vérifier le niveau de vérification pour publier un parking
    if (user.verificationLevel < VerificationLevel.LEVEL_3) {
      throw new BadRequestException(
        `Vous devez atteindre le niveau de vérification 3 pour publier un parking. Veuillez compléter la vérification de votre identité.`
      );
    }
    
    // Limiter le nombre de parkings selon le niveau
    const parkingsLimit = {
      [VerificationLevel.LEVEL_3]: 3,
      [VerificationLevel.LEVEL_4]: Infinity,
    };
    
    const limit = parkingsLimit[user.verificationLevel] || 0;
    
    const userParkings = await this.parkingsRepository.count({
      where: { ownerId: userId },
    });
    
    if (userParkings >= limit) {
      throw new BadRequestException(
        `Votre niveau de vérification actuel (${user.verificationLevel}) limite le nombre de parkings à ${limit}. Veuillez compléter la vérification avancée pour augmenter cette limite.`
      );
    }    // Création du point géographique
    const point = `POINT(${createParkingDto.longitude} ${createParkingDto.latitude})`;
    
    const parking = this.parkingsRepository.create({
      ...createParkingDto,
      ownerId: userId,
      location: point,
    });
    
    return this.parkingsRepository.save(parking);
  }

  async findAll(userId?: string): Promise<Parking[]> {
    if (userId) {
      return this.parkingsRepository.find({
        where: { ownerId: userId },
        order: { createdAt: 'DESC' },
      });
    }
    
    return this.parkingsRepository.find({
      where: { isActive: true },
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(id: string): Promise<Parking> {
    const parking = await this.parkingsRepository.findOne({
      where: { id },
      relations: ['priceRules'],
    });
    
    if (!parking) {
      throw new NotFoundException(`Parking avec l'id ${id} non trouvé`);
    }
    
    return parking;
  }

  async update(id: string, userId: string, updateParkingDto: UpdateParkingDto): Promise<Parking> {
    const parking = await this.findOne(id);
    
    // Vérifier si l'utilisateur est le propriétaire
    if (parking.ownerId !== userId) {
      throw new ForbiddenException('Vous n\'êtes pas autorisé à modifier ce parking');
    }
    
    // Mise à jour du point géographique si nécessaire
    if (updateParkingDto.latitude && updateParkingDto.longitude) {
      const point = `POINT(${updateParkingDto.longitude} ${updateParkingDto.latitude})`;
      updateParkingDto['location'] = point;
    }
    
    const updatedParking = Object.assign(parking, updateParkingDto);
    return this.parkingsRepository.save(updatedParking);
  }

  async remove(id: string, userId: string): Promise<void> {
    const parking = await this.findOne(id);
    
    // Vérifier si l'utilisateur est le propriétaire
    if (parking.ownerId !== userId) {
      throw new ForbiddenException('Vous n\'êtes pas autorisé à supprimer ce parking');
    }
    
    await this.parkingsRepository.remove(parking);
  }

  async search(searchParams: SearchParkingDto): Promise<Parking[]> {
    let query = this.parkingsRepository.createQueryBuilder('parking')
      .where('parking.isActive = :isActive', { isActive: true });
    
    // Recherche par géolocalisation
    if (searchParams.latitude && searchParams.longitude && searchParams.radius) {
      const point = `POINT(${searchParams.longitude} ${searchParams.latitude})`;
      const radiusInMeters = searchParams.radius;
      
      query = query
        .andWhere(`ST_DWithin(
          parking.location::geography, 
          ST_GeographyFromText(:point)::geography, 
          :radius
        )`, {
          point: point,
          radius: radiusInMeters
        });
    }
    
    // Filtrage par prix maximum
    if (searchParams.maxPrice) {
      query = query.andWhere('parking.basePrice <= :maxPrice', { 
        maxPrice: searchParams.maxPrice 
      });
    }
    
    // Filtrage par caractéristiques
    if (searchParams.features && searchParams.features.length > 0) {
      for (const feature of searchParams.features) {
        query = query.andWhere('parking.features @> :feature', { 
          feature: JSON.stringify([feature]) 
        });
      }
    }
    
    // Filtrage par borne de recharge EV
    if (searchParams.hasEVCharging !== undefined) {
      query = query.andWhere('parking.hasEVCharging = :hasEVCharging', { 
        hasEVCharging: searchParams.hasEVCharging 
      });
    }
    
    // Recherche par emplacement (texte)
    if (searchParams.location) {
      query = query.andWhere('(parking.address ILIKE :location OR parking.title ILIKE :location)', {
        location: `%${searchParams.location}%`
      });
    }
    
    // Pagination
    const limit = searchParams.limit || 10;
    const offset = searchParams.offset || 0;
    
    query = query
      .orderBy('parking.createdAt', 'DESC')
      .take(limit)
      .skip(offset);
    
    return query.getMany();
  }

  async checkAvailability(
    parkingId: string, 
    startDateTime: Date, 
    endDateTime: Date
  ): Promise<boolean> {
    const parking = await this.findOne(parkingId);
    
    // Vérifier si la période demandée est dans les horaires d'ouverture
    // et s'il n'y a pas de réservation qui chevauche cette période
    
    // Logique simplifiée pour l'exemple - à adapter selon vos besoins
    const dayOfWeek = startDateTime.getDay(); // 0-6, 0 étant dimanche
    const days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
    const dayName = days[dayOfWeek];
    
    // Vérifier les horaires d'ouverture
    const dayAvailability = parking.availability[dayName];
    if (!dayAvailability || dayAvailability.length === 0) {
      return false; // Ce jour n'est pas disponible
    }
    
    // Vérifier les exceptions
    if (parking.availability.exceptions) {
      const dateString = startDateTime.toISOString().split('T')[0];
      const exception = parking.availability.exceptions.find(e => e.date === dateString);
      
      if (exception) {
        if (!exception.available) {
          return false; // Jour exceptionnellement fermé
        }
        if (exception.hours && exception.hours.length > 0) {
          // Logique pour vérifier les heures exceptionnelles
          // ...
        }
      }
    }
    
    // Vérifier si l'heure est dans une plage horaire disponible
    const startHour = `${startDateTime.getHours().toString().padStart(2, '0')}:${startDateTime.getMinutes().toString().padStart(2, '0')}`;
    const endHour = `${endDateTime.getHours().toString().padStart(2, '0')}:${endDateTime.getMinutes().toString().padStart(2, '0')}`;
    
    const isInTimeRange = dayAvailability.some(range => {
      return startHour >= range.start && endHour <= range.end;
    });
    
    if (!isInTimeRange) {
      return false; // Hors des plages horaires disponibles
    }
    
    // TODO: Vérifier s'il n'y a pas de réservation qui chevauche cette période
    // Cela nécessiterait d'implémenter un service de réservation et de l'injecter ici
    
    return true;
  }

  async updateBasePrice(id: string, newBasePrice: number): Promise<Parking> {
    const parking = await this.findOne(id);
    parking.basePrice = newBasePrice;
    return this.parkingsRepository.save(parking);
  }
}